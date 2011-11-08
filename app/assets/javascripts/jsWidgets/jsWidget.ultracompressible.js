/*
 * Javascript Widget Engine v0.0.1
 *
 * Copyright 2009-2010, Subramaya Sastry
 * Dual licensed under the MIT or GPL Version 2 licenses.
 *
 * Date: Tue Mar 30 11:00:00 AM CT
 */

/* ***********************************************************************
 * NOTES: 
 * For enabling code compression, use local variables as much as possible.
 * This is the reason why you see a lot of copies of global variables
 * and object properties into local variables in the js code below with a corresponding comment
 * ************************************************************************/

  // Test for whether a variable is defined
function _GLOB_isDefined(v)  { return (typeof v != 'undefined'); }

  // Apply the function 'f' to each element of the array
  // Do not extend the array prototype to avoid conflicts with mods on the host site
function _GLOB_iterateOverArray(a, f) { var l = a.length; for (var i = 0; i < l; i++) f(a[i]); }

// Widget constructor!
function _Widget(widgetFormat)
{
  this.wf = widgetFormat;
  this.baseUrl = widgetFormat.base_url;
  this.rootDIV = '';
  this.init();
  if (!_GLOB_isDefined(this.baseUrl)) this.baseUrl = '';
}

_Widget.prototype = {
  init: function() {
      var widget  = this;                    // COMPRESSION
      var widgetFormat = widget.wf;               // COMPRESSION
      var cssPrefs = widgetFormat.base_css_prefs;  // COMPRESSION

        // some shortcuts
      widget.hoverStyle = (cssPrefs.link_class || !_GLOB_isDefined(cssPrefs.link_hover_style)) ? '' : cssPrefs.link_hover_style;
    },

    // Set a style on a DOM element
  _PRIV_setStyle: function(elt, clazz, styleText) {
      var widget = this;                        // COMPRESSION
      var cssPrefs = widget.wf.base_css_prefs;  // COMPRESSION

      if (clazz) {
        elt.setAttribute((document.all ? 'className' : 'class'), clazz);  // IE7 behavior is different from the rest of the pack!
      }
      else if (styleText) {
           // this is for IE7 and not sure which other browsers
        if (elt.style.setAttribute) {
          elt.style.setAttribute('cssText', styleText);

             // If a hover style is present, mimic it with onmouseover & onmouseout js handlers
          if ((elt.tagName == 'A') && widget.hoverStyle) {
            elt.onmouseover = function() { this.style.setAttribute('cssText', styleText + ';' + widget.hoverStyle); }
            elt.onmouseout  = function() { this.style.setAttribute('cssText', styleText); }
          }
        }
           // this is for FF, Safari, and not sure which other browsers
        else {
          elt.setAttribute('style', styleText); 

             // If a hover style is present, mimic it with onmouseover & onmouseout js handlers
          if ((elt.tagName == 'A') && widget.hoverStyle) {
            elt.onmouseover = function() { this.setAttribute('style', styleText + ';' + widget.hoverStyle); }
            elt.onmouseout  = function() { this.setAttribute('style', styleText); }
          }
        }
      }
        // if the element is an anchor element, retry with the generic style!
      else if ((elt.tagName == 'A') && (cssPrefs.link_style || cssPrefs.link_class)) {
        widget._PRIV_setStyle(elt, cssPrefs.link_class, cssPrefs.link_style);
      }
    },

  _PRIV_createElement: function(type, clazz, style) {
      var elt = document.createElement(type);
      this._PRIV_setStyle(elt, clazz, style);
      return elt;
    },

  _PRIV_computeExpr: function(str, dataObj) {
      function fetchExprValue(w, d, vRef) {
        return eval(vRef.substring(1, vRef.length-1).replace(/\$util\./g, "w.helpers.").replace(/\$/g, "d")); 
      }

      var widget       = this;
      var widgetFormat = this.wf;
      var refs = str.match(/\{.*?\}/g);
      if (refs)
        _GLOB_iterateOverArray(refs, function(arrayElt) { str = str.replace(arrayElt, fetchExprValue(widget, dataObj, arrayElt)); });

      return str;
    },

  _PRIV_processNewDOMElement: function(dataObj, eltData, eltParams, newDOMElt, newDOMEltParams, isLastDOMElt) {
      var widget   = this;
      var cssPrefs = widget.wf.base_css_prefs;
      var baseUrl  = widget.baseUrl;

        // If there isn't any DOM, the element data is rendered as plain text!
      if (!newDOMElt) {
        newDOMElt = document.createTextNode(eltData);
      }
        // Handle img element specially
      else if (newDOMElt.tagName == 'IMG') {
        var srcExpr = (newDOMEltParams && newDOMEltParams.src) ? widget._PRIV_computeExpr(newDOMEltParams.src, dataObj) : baseUrl;
        if (srcExpr.indexOf("http://") == -1)
          srcExpr = baseUrl + srcExpr;
        newDOMElt.src = srcExpr;
        newDOMElt.alt = eltData;
      }
        // If it is not an 'A' element, the element data becomes inner html of the last dom element.
      else if (newDOMElt.tagName != 'A') {
        if (isLastDOMElt)
          newDOMElt.innerHTML = eltData;
      }
      else {
          // If newDOMEltParams.url is undefined, link this element back to the base url!
        var urlExpr = (newDOMEltParams && newDOMEltParams.url) ? widget._PRIV_computeExpr(newDOMEltParams.url, dataObj) : baseUrl;
        if (urlExpr.indexOf("http://") == -1)
          urlExpr = baseUrl + urlExpr;
        newDOMElt.href   = urlExpr;
        newDOMElt.target = cssPrefs.link_target;
        if (isLastDOMElt) {
            // If it is an 'a' element, the element name becomes the link text, unless the
            // dom element itself provides the link text in which case, the element name is ignored!
          var linkExpr = (newDOMEltParams && newDOMEltParams.text) ? newDOMEltParams.text : eltData;
          newDOMElt.innerHTML = widget._PRIV_computeExpr(linkExpr, dataObj);
        }

          // Set the generic link style if the widget format doesn't provide any style for this link!
        if (!newDOMEltParams.clazz && !newDOMEltParams.style)
          widget._PRIV_setStyle(newDOMElt, cssPrefs.link_class, cssPrefs.link_style);
      }
      return newDOMElt;
    },

  _PRIV_buildDataElementContainer: function(dataObj, what, whatParams) {
      var widget = this; // COMPRESSION
      var rootElt     = '';
      var leafElt     = '';
      var eltDOMArray = _GLOB_isDefined(whatParams.how) ? whatParams.how : [];
      var depth       = eltDOMArray.length;

      /**
       * This code goes through the array of HTML element specs,
       * constructs one elements at a time, and nests each new element
       * within the previous element.
       */
      for (var i = 0; i < depth; i++) {
        var isLast;
        var params = eltDOMArray[i];
        var newElt;
        if (params.elt == 'dom_tree') {
           newElt = widget._PRIV_buildWidgetSectionDOM(params.root_elt, dataObj, params);
             // The data/inner-html for this new element comes from the children which have already been built!
             // So, nothing more to add to it anymore -- simply process href, srcs, etc.
           this._PRIV_processNewDOMElement(dataObj, '', [], newElt, params, false);
        }
        else {
          newElt = this._PRIV_createElement(params.elt, params.clazz, params.style);
          isLast = (i == (depth-1));
          this._PRIV_processNewDOMElement(dataObj, what, whatParams, newElt, params, isLast);
        }

        if (!rootElt)
          rootElt = newElt;
        else
          leafElt.appendChild(newElt);

        leafElt = newElt;
      }

        /* No DOM specs provided -- so, run the dom element processor to generate a default element */
      if (depth == 0)
        rootElt = this._PRIV_processNewDOMElement(dataObj, what, whatParams, '', params, true);

      return rootElt;
    },

  _PRIV_addSeparator: function(container, sep) {
      if (sep) {
          // Process "\n" newline elements at the beginning and strip them off the separator
        if (sep.substring(0,1) == '\n') {
          container.appendChild(document.createElement('br'));
          sep = sep.substring(1);
        }
        if (sep)
          container.appendChild(document.createTextNode(sep));
      }
    },

  _PRIV_addDataElement: function(dataObj, formatParams, containerElt) {
      var widget = this; // COMPRESSION

        // Fetch the 'what' element
      var elt = _GLOB_isDefined(formatParams.what) ? formatParams.what : '';

         // Check for presence of a condition
      if (_GLOB_isDefined(formatParams.if_true)) {
        var val = widget._PRIV_computeExpr(formatParams.if_true, dataObj);
        if (val == 'undefined' || !val)
          return;
      }

        // Compute the data for the 'what' element -- return if empty!
      if (elt) {
        var eltData = widget._PRIV_computeExpr(elt, dataObj);
        if (!eltData)
          return;
      }

        // Add the prefix separator!
      if (formatParams.prefix)
        widget._PRIV_addSeparator(containerElt, formatParams.prefix);

        // Now process the DOM specs. of the 'what' element
      var rootElt = widget._PRIV_buildDataElementContainer(dataObj, eltData, formatParams);
      if (rootElt)
        containerElt.appendChild(rootElt);

        // Add the suffix separator!
      if (formatParams.suffix)
        widget._PRIV_addSeparator(containerElt, formatParams.suffix);
    },

  _PRIV_buildWidgetSectionChildren: function(sectionData, childFormats, parentElt) {
      var widget = this;
      _GLOB_iterateOverArray(childFormats, function(arrayElt) { widget._PRIV_addDataElement(sectionData, arrayElt, parentElt); });
    },

  _PRIV_buildWidgetSectionDOM: function(rootEltType, itemData, sectionFormat) {
      var itemDIV = this._PRIV_createElement(rootEltType, sectionFormat.clazz, sectionFormat.style);
      this._PRIV_buildWidgetSectionChildren(itemData, sectionFormat.dom_nodes, itemDIV);
      return itemDIV;
    },

    // This method builds a specific section of the widget
  _PRIV_buildWidgetSection: function(sectionFormat) {
      var secData = eval(sectionFormat.data);

      if (sectionFormat.loop) {
          // Generic section div
        var secDIV = this._PRIV_createElement('div', '', '');

          // Items within this section
        var count = 0;
        var numReqdItems = sectionFormat.num_items;
        var l = secData.length;
        for (var i = 0; i < l; i++) {
          if ((count == numReqdItems)) // We are done!
            break;

            // Build the item (story, for example) and append it to the section div
          secDIV.appendChild(this._PRIV_buildWidgetSectionDOM('div', secData[i], sectionFormat));

          count++;
        }

        return secDIV;
      }
      else {
          // Build the section (header / footer, for example)
        return this._PRIV_buildWidgetSectionDOM('div', secData, sectionFormat);
      }
    },

    // Generate the root widget div
  _PRIV_generateWidgetDiv: function() {
        // local vars. to ensure better code compression!
      var widget = this;
      var baseUrl = widget.baseUrl;
      var widgetFormat = widget.wf;
      var cssPrefs = widgetFormat.base_css_prefs;

        // Construct a top-level widget div
      var widgetDIV = widget._PRIV_createElement('div', cssPrefs.clazz, cssPrefs.style);

        // Build all the widget sections
      _GLOB_iterateOverArray(widgetFormat.sections, function(arrayElt) { widgetDIV.appendChild(widget._PRIV_buildWidgetSection(widgetFormat[arrayElt])); });

        // Record the div
      widget.rootDIV = widgetDIV;

      return widgetDIV;
    },

    // Replace 'replNode' with a generated widget div
  installOver: function(replNode) { replNode.parentNode.replaceChild(this._PRIV_generateWidgetDiv(), replNode); },

    // Replace the old widget DIV with a new generated widget
  refresh: function() { this.installOver(this.rootDIV); },

  // ---------- These functions are helper functions and is not strictly needed in this file, but are commonly used in some of my widgets! ----------
  helpers : {
    _PRIV_truncateTextChars: function(s, numChars, minChars, separator) {
    // truncate string s to numChars. Add ... to the end if it's > numChars. Try to truncate on a word boundary
    // if separator is passed (e.g., a ',') then use that to split the words/phrases.  If it cannot find a word
    // boundary to truncate on, it will simply chop the string in the middle of a word!

      if (!s || (s.length <= numChars)) {
        return s;
      }
      else {
        s = s.substring(0,numChars);

        var pos = s.lastIndexOf(separator);
        if (pos > minChars) {
          s = s.substring(0,pos);
        }
        else if (separator != ' ') {
          pos = s.lastIndexOf(' ');
          if (pos > minChars)
            s = s.substring(0,pos);
        }
            
        return s + ' ...';
      } 
    },

    _PRIV_smartTruncate: function(s, maxLen) { return this._PRIV_truncateTextChars(s, maxLen, maxLen-15, ' '); },

    trimString : function(str, maxLen) { return (!maxLen) ? str : this._PRIV_smartTruncate(str, maxLen); },

    /* 
     * This function formats dateString using the formatting string dateFormat 
     *
     * dateFormat replacement semantics are:
     * m  --> 2 digit month without leading 0's (1, 2, ..., 9, 10, 11, 12)
     * mm --> 2 digit month with leading 0's    (01, 02 ..., 09, 10, 11, 12)
     * M  --> 3-letter month abbreviation with first letter capitalized (Jan, .. Dec)
     * MM --> Full month name with the first letter capitalized (January, .. December)
     * d  --> 2 digit day without leading 0's   (1, 2, ..., 9, 10, ... 31)
     * dd --> 2 digit day with leading 0's      (01, 02, ..., 09, 10, ... 31)
     * y  --> 4 digit year
     *
     * Every other character in the output dateFormat is copied over verbatim
     */
    formatDate: function(dateStr, separator, inputFormat, outputFormat)
    {
      var month_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      function setMonth(inputHash, m)
      {
        m = String(m).replace(/^0/, '');
        inputHash['m']  = m;
        inputHash['mm'] = m < 10 ? '0' + m : m;
        inputHash['MM'] = month_names[m-1];
        inputHash['M']  = month_names[m-1].substr(0,3);
      }

      function setDate(inputHash, d)
      {
        d = String(d).replace(/^0/, '');
        inputHash['d']  = d;
        inputHash['dd'] = d < 10 ? '0' + d : d;
      }

      if (!inputFormat || !outputFormat)
        return dateStr;

        // inFormat is of the form: y/m/d or d.m.y
        // y, m, d signifying year, month day with the separator between them
      var inputFormatFields = inputFormat.split(separator);
      var vals              = dateStr.split(separator);

        // Map date string to the input format
      var inputHash = {}
      var l = inputFormatFields.length;
      for (i = 0; i < l; i++)
        inputHash[inputFormatFields[i]] = vals[i];

        // Massage month into various desired formats
      if (inputHash['m'] || inputHash['mm']) {
        setMonth(inputHash, inputHash['m'] ? inputHash['m'] : inputHash['mm']);
      }
      else if (inputHash['MM']) {
        for (i = 0; i < 12; i++) {
          if (month_names[i] == inputHash['MM']) {
            setMonth(inputHash, i+1);
            break;
          }
        }
      }
      else if (inputHash['M']) {
        for (i = 0; i < 12; i++) {
          if (month_names[i].substr(0,3) == inputHash['M']) {
            setMonth(inputHash, i+1);
            break;
          }
        }
      }

        // Massage date into various desired formats
      setDate(inputHash, inputHash['d'] ? inputHash['d'] : inputHash['dd']);

        // ORDER of these expressions is important!
      var outputFormatFields = ['y', 'dd', 'd', 'mm', 'm', 'MM', 'M'];

        // Now generate the output format
      var output = outputFormat;
      var l = outputFormatFields.length;
      for (i = 0; i < l; i++)
        output = output.replace(outputFormatFields[i], inputHash[outputFormatFields[i]]);

      return output;
    }
  }
}
