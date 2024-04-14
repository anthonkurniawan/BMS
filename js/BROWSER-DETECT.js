				
	var a=navigator.userAgent.toLowerCase();
	var O="";
	
	if(/msie/.test(a)) O="-ms-";
	else if(/chrome/.test(a)||/safari/.test(a)||/yandex/.test(a)) O="-webkit-";
	else if(/mozilla/.test(a)) O="-moz-";
	else if(/opera/.test(a)) O="-o-";
	else if(/konqueror/.test(a)) O="-khtml-";
	else O="";

var w = window;
( w.opera && navigator.userAgent.indexOf( "Chrome" ) === -1 )

$.ui.ie = !!/msie [\w.]+/.exec( navigator.userAgent.toLowerCase() );

!( window.navigator.userAgent.indexOf( "Firefox" ) >= 0 && window.top !== window ) && ( window.navigator.userAgent.search(/CriOS/) === -1 )
		
/iPhone|iPad|iPod/.test( navigator.platform ) && navigator.userAgent.indexOf( "AppleWebKit" ) > -1, // This option defaults to true on iOS devices.

		
function fixedPosition() {
	var w = window,
		ua = navigator.userAgent,
		platform = navigator.platform,
		// Rendering engine is Webkit, and capture major version
		wkmatch = ua.match( /AppleWebKit\/([0-9]+)/ ),
		wkversion = !!wkmatch && wkmatch[ 1 ],
		ffmatch = ua.match( /Fennec\/([0-9]+)/ ),
		ffversion = !!ffmatch && ffmatch[ 1 ],
		operammobilematch = ua.match( /Opera Mobi\/([0-9]+)/ ),
		omversion = !!operammobilematch && operammobilematch[ 1 ];

	if (
		// iOS 4.3 and older : Platform is iPhone/Pad/Touch and Webkit version is less than 534 (ios5)
		( ( platform.indexOf( "iPhone" ) > -1 || platform.indexOf( "iPad" ) > -1  || platform.indexOf( "iPod" ) > -1 ) && wkversion && wkversion < 534 ) ||
		// Opera Mini
		( w.operamini && ({}).toString.call( w.operamini ) === "[object OperaMini]" ) ||
		( operammobilematch && omversion < 7458 )	||
		//Android lte 2.1: Platform is Android and Webkit version is less than 533 (Android 2.2)
		( ua.indexOf( "Android" ) > -1 && wkversion && wkversion < 533 ) ||
		// Firefox Mobile before 6.0 -
		( ffversion && ffversion < 6 ) ||
		// WebOS less than 3
		( "palmGetResource" in window && wkversion && wkversion < 534 )	||
		// MeeGo
		( ua.indexOf( "MeeGo" ) > -1 && ua.indexOf( "NokiaBrowser/8.5.0" ) > -1 ) ) {
		return false;
	}
	return true;
}

androidBlacklist = ( function() {
				var ua = navigator.userAgent,
					// Rendering engine is Webkit, and capture major version
					wkmatch = ua.match( /AppleWebKit\/([0-9\.]+)/ ),
					wkversion = !!wkmatch && wkmatch[ 1 ],
					androidmatch = ua.match( /Android (\d+(?:\.\d+))/ ),
					andversion = !!androidmatch && androidmatch[ 1 ],
					chromematch = ua.indexOf( "Chrome" ) > -1;

				// Platform is Android, WebKit version is greater than 534.13 ( Android 3.2.1 ) and not Chrome.
				if ( androidmatch !== null && andversion === "4.0" && wkversion && wkversion > 534.13 && !chromematch ) {
					return true;
				}
				return false;
			}());
			
//check the browser and version and run needed workarounds
		_workarounds: function() {
			var ua = navigator.userAgent,
			platform = navigator.platform,
			// Rendering engine is Webkit, and capture major version
			wkmatch = ua.match( /AppleWebKit\/([0-9]+)/ ),
			wkversion = !!wkmatch && wkmatch[ 1 ],
			os = null,
			self = this;
			//set the os we are working in if it dosent match one with workarounds return
			if ( platform.indexOf( "iPhone" ) > -1 || platform.indexOf( "iPad" ) > -1  || platform.indexOf( "iPod" ) > -1 ) {
				os = "ios";
			} else if ( ua.indexOf( "Android" ) > -1 ) {
				os = "android";
			} else {
				return;
			}
			//check os version if it dosent match one with workarounds return
			if ( os === "ios" ) {
				//iOS  workarounds
				self._bindScrollWorkaround();
			} else if ( os === "android" && wkversion && wkversion < 534 ) {
				//Android 2.3 run all Android 2.3 workaround
				self._bindScrollWorkaround();
				self._bindListThumbWorkaround();
			} else {
				return;
			}
		},
		
// This fix addresses an iOS bug, so return early if the UA claims it's something else.
	var ua = navigator.userAgent,
		zoom,
		evt, x, y, z, aig;
	if ( !( /iPhone|iPad|iPod/.test( navigator.platform ) && /OS [1-5]_[0-9_]* like Mac OS X/i.test( ua ) && ua.indexOf( "AppleWebKit" ) > -1 ) ) {
		$.mobile.iosorientationfixEnabled = false;
		return;
	}
	
nokiaLTE7_3 = (function() {
	var ua = window.navigator.userAgent;
	//The following is an attempt to match Nokia browsers that are running Symbian/s60, with webkit, version 7.3 or older
	return ua.indexOf( "Nokia" ) > -1 &&
			( ua.indexOf( "Symbian/3" ) > -1 || ua.indexOf( "Series60/5" ) > -1 ) &&
			ua.indexOf( "AppleWebKit" ) > -1 &&
			ua.match( /(BrowserNG|NokiaBrowser)\/7\.[0-3]/ );
})();
