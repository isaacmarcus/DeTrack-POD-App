'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "0a4fb26f5f4efc1b8821daf81be22c1e",
"assets/assets/fonts/RobotoMono/RobotoMono-Bold.ttf": "e72fdf1cca2cebcbe91325bbe9f9e5da",
"assets/assets/fonts/RobotoMono/RobotoMono-BoldItalic.ttf": "9f19015ac5913e03cdd542eb73d17d12",
"assets/assets/fonts/RobotoMono/RobotoMono-ExtraLight.ttf": "9bab8fe7af63fb4a1d536f0690799953",
"assets/assets/fonts/RobotoMono/RobotoMono-ExtraLightItalic.ttf": "2186a1bc18fe3a5b9d35b1f0a9661f97",
"assets/assets/fonts/RobotoMono/RobotoMono-Italic.ttf": "4e76966e85cfc4edb3db058576edcb1b",
"assets/assets/fonts/RobotoMono/RobotoMono-Light.ttf": "fa8ab495d494eccb28f4431f054ddbd4",
"assets/assets/fonts/RobotoMono/RobotoMono-LightItalic.ttf": "060d28a8c0576728842455c0a92641e0",
"assets/assets/fonts/RobotoMono/RobotoMono-Medium.ttf": "8ad82b1dc550319993a7d6c932b2656d",
"assets/assets/fonts/RobotoMono/RobotoMono-MediumItalic.ttf": "50fcbc561a338706746be330f2b7ef99",
"assets/assets/fonts/RobotoMono/RobotoMono-Regular.ttf": "e5ca8c0ac474df46fe45840707a0c483",
"assets/assets/fonts/RobotoMono/RobotoMono-SemiBold.ttf": "2a12618b6d46fd798157e4b9d29cdf06",
"assets/assets/fonts/RobotoMono/RobotoMono-SemiBoldItalic.ttf": "e0781b003f2cd1145518cc5f5f8d134c",
"assets/assets/fonts/RobotoMono/RobotoMono-Thin.ttf": "7cb58857d294ac1e09b72ea9403c690a",
"assets/assets/fonts/RobotoMono/RobotoMono-ThinItalic.ttf": "95e08d0c587d02c33914026841dd5e89",
"assets/FontManifest.json": "6970f4e567c7f7ced573945e0bb7b237",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/NOTICES": "714a51caffd0136c717d791fc8db5ca0",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/android-icon-144x144.png": "0179c115cfec1f779815a7380f185a5f",
"icons/android-icon-192x192.png": "3eb3e00c80ccb7b1e74af72ad5bdf969",
"icons/android-icon-36x36.png": "08286cd411d7d55e36856d8bd19e02f9",
"icons/android-icon-48x48.png": "4a74e63998b553ec3eb8b912e07946b3",
"icons/android-icon-72x72.png": "f447a07443a92ef1cf689f65126fa3ac",
"icons/android-icon-96x96.png": "0a485238ff70b84990f2293e79c5e047",
"icons/apple-icon-114x114.png": "b1a4611269a3732478025df6f1ab71b0",
"icons/apple-icon-120x120.png": "33bf91d9213b004ae727822505043ff7",
"icons/apple-icon-144x144.png": "0179c115cfec1f779815a7380f185a5f",
"icons/apple-icon-152x152.png": "7b77e5db01ecb3f7d8227377f6aa0938",
"icons/apple-icon-180x180.png": "ea06018d2cf73bea00554810f6f0a814",
"icons/apple-icon-57x57.png": "5f9c512aa64e8369997c3f81d01532e9",
"icons/apple-icon-60x60.png": "6fcbac5ed90879cad429952bb7dd86ae",
"icons/apple-icon-72x72.png": "f447a07443a92ef1cf689f65126fa3ac",
"icons/apple-icon-76x76.png": "dbc5ab39aa18b7af0cc8ba45b032708c",
"icons/apple-icon-precomposed.png": "c81c518aff2dc5963a98d6dba0432fde",
"icons/apple-icon.png": "c81c518aff2dc5963a98d6dba0432fde",
"icons/browserconfig.xml": "97775b1fd3b6e6c13fc719c2c7dd0ffe",
"icons/favicon-16x16.png": "062272d05be3eb43a439cf3c81e17d44",
"icons/favicon-32x32.png": "26675429f842a00901df449e717878ff",
"icons/favicon-96x96.png": "0a485238ff70b84990f2293e79c5e047",
"icons/favicon.ico": "e6e09f545293fcbf2c7e1aa5ea7b5bcd",
"icons/manifest.json": "1c892a9f007954727661d80f6fad7587",
"icons/ms-icon-144x144.png": "0179c115cfec1f779815a7380f185a5f",
"icons/ms-icon-150x150.png": "9903ea8cae8a508f618641022660aabe",
"icons/ms-icon-310x310.png": "366774cdd8789173b79ccbf59e569f67",
"icons/ms-icon-70x70.png": "00f683e40e574275e8a4ac827cb8e8e1",
"index.html": "9bf777c20b3748fadb51991bbb47fcae",
"/": "9bf777c20b3748fadb51991bbb47fcae",
"main.dart.js": "d0e611209ed4fdc526216d6921ed8a58",
"manifest.json": "14fd2a10b8b4ab98d1a972163af47896",
"splash/style.css": "c5ffbb4de20cbf8aa62de8d523e85dd1",
"version.json": "aa39e4a6ed0e155981e8768adf7b0985"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
