'use strict';

const OFFLINE_CACHE = 'offline-cache-v1';
const FILES_TO_CACHE = [
  '/offline',
  '/images/SadDoge.jpg',
  '/font/arcade/PressStart2P.woff'
]

self.addEventListener('install', (evt) => {
  console.info('[ServiceWorker] Install');
  evt.waitUntil(
    caches.open(OFFLINE_CACHE).then((cache) => {
      console.info('[ServiceWorker] Pre-caching offline page');
      return cache.addAll(FILES_TO_CACHE);
    })
  );
  self.skipWaiting();
});

self.addEventListener('activate', (evt) => {
  console.info('[ServiceWorker] Activate');
  caches.keys().then((keyList) => {
    return Promise.all(keyList.map((key) => {
      if (key !== OFFLINE_CACHE) {
        console.info("[ServiceWorker] removing old cache", key)
        return caches.delete(key);
      }
    }))
  })
  self.clients.claim();
});


self.addEventListener('fetch', (evt) => {
  if (evt.request.mode == 'navigate') {
    evt.respondWith(
      fetch(evt.request)
          .catch(() => {
            return caches.open(OFFLINE_CACHE)
                .then((cache) => {
                  return cache.match('/offline');
                });
          })
      );
      return;
  }

    evt.respondWith(
      fetch(evt.request)
          .catch(() => {
            return caches.open(OFFLINE_CACHE)
                .then((cache) => {
                  return cache.match(evt.request);
                });
          })
      );
});
