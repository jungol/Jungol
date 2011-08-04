var d = document;
var safari = (navigator.userAgent.toLowerCase().indexOf('safari') != -1) ? true : false;
var gebtn = function(parEl,child) { return parEl.getElementsByTagName(child); };
onload = function() {

    var body = gebtn(d,'body')[0];
    body.className = body.className && body.className != '' ? body.className + ' has-js' : 'has-js';

    if (!d.getElementById || !d.createTextNode) return;
    var ls = gebtn(d,'label');
    for (var i = 0; i < ls.length; i++) {
        var l = ls[i];
        if (l.className.indexOf('label_') == -1) continue;
        var inp = gebtn(l,'input')[0];
        if (l.className == 'check') {
            l.className = (safari && inp.checked == true || inp.checked) ? 'check c-on' : 'check cc-off';
            l.onclick = check_it;
        };
        if (l.className == 'completed-radio') {
            l.className = (safari && inp.checked == true || inp.checked) ? 'completed-radio cr-on' : 'completed-radio cr-off';
            l.onclick = turn_radio;
        };
				if (l.className == 'progress-radio') {
            l.className = (safari && inp.checked == true || inp.checked) ? 'progress-radio pr-on' : 'progress-radio pr-off';
            l.onclick = turn_radio;
        };
    };
};
var check_it = function() {
    var inp = gebtn(this,'input')[0];
    if (this.className == 'check c_off' || (!safari && inp.checked)) {
        this.className = 'check c-on';
        if (safari) inp.click();
    } else {
        this.className = 'check c-off';
        if (safari) inp.click();
    };
};
var turn_completed_radio = function() {
    var inp = gebtn(this,'input')[0];
    if (this.className == 'completed-radio cr-off' || inp.checked) {
        var ls = gebtn(this.parentNode,'label');
        for (var i = 0; i < ls.length; i++) {
            var l = ls[i];
            if (l.className.indexOf('comleted-radio') == -1)  continue;
            l.className = 'completed-radio cr-off';
        };
        this.className = 'completed-radio cr-on';
        if (safari) inp.click();
    } else {
        this.className = 'completed-radio cr-off';
        if (safari) inp.click();
    };
};
var turn_progress_radio = function() {
    var inp = gebtn(this,'input')[0];
    if (this.className == 'progress-radio pr-off' || inp.checked) {
        var ls = gebtn(this.parentNode,'label');
        for (var i = 0; i < ls.length; i++) {
            var l = ls[i];
            if (l.className.indexOf('progress-radio') == -1)  continue;
            l.className = 'progress-radio pr-off';
        };
        this.className = 'progress-radio pr-on';
        if (safari) inp.click();
    } else {
        this.className = 'progress-radio pr-off';
        if (safari) inp.click();
    };
};