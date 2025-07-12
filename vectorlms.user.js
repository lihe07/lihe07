// ==UserScript==
// @name         VectorLMS
// @namespace    http://tampermonkey.net/
// @version      2025-07-11
// @description  try to take over the world!
// @author       You
// @match        https://gatechlmsstudents-ga.vectorlmsedu.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=vectorlmsedu.com
// @grant        none
// @run-at       document-idle
// ==/UserScript==


function parseCourseUrl(url) {
  // Course url: httpX://host/training/player/<course_item_id>/<course_work_id>?...
  let match = url.match(/\/training\/player\/([^/]+)\/([^?]+)/);
  return match ? { courseItemId: match[1], courseWorkId: match[2] } : null;
}

async function trackStart(course) {
  const formData = new URLSearchParams();
  formData.append('course_item_id', course.courseItemId);
  formData.append('course_work_id', course.courseWorkId);
  formData.append('metadata[lang]', 'en');
  formData.append('metadata[player_name]', 'SLIP');
  formData.append('metadata[player_version]', 'https://a.trainingcdn.com/sl_jwplayer/v2025.PI.25.2.4.slip/js/sl_jwplayer.js');
  formData.append('metadata[player_backend]', 'videojs');
  formData.append('metadata[player_backend_version]', '7.5.4');


  // POST /rpc/v2/json/training/tracking_start
  const resp = await fetch('/rpc/v2/json/training/tracking_start', {
    method: 'POST',
    body: formData.toString(),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
  })

  const data = await resp.json();
  console.log('Tracking start response:', data);

  return data
}

async function trackFinish(course, course_work_hist_id) {
  const formData = new URLSearchParams();
  formData.append('course_work_hist_id', course_work_hist_id);
  formData.append('json', "{}");

  const resp = await fetch('/rpc/v2/json/training/tracking_finish',
    {
      method: 'POST',
      body: formData.toString(),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    })

  const status = resp.status;
  const data = await resp.text();
  console.log('Tracking finish response:', status, data);
}

function findAllCourses() {
  const courses = [];
  const links = document.querySelectorAll('a.TOC_item');
  links.forEach(link => {
    // Check if finished
    let checkIcon = link.querySelector(".fa-check")
    if (checkIcon) {
      return; // Skip if the course is already finished
    }

    const url = link.href;
    const course = parseCourseUrl(url);

    // Parse length in minutes
    const timeElement = link.querySelector('.span_link');
    // 'About . Minutes'
    const timeMatch = timeElement ? timeElement.textContent.match(/About (\d+) Minutes/) : null;
    const length = timeMatch ? parseInt(timeMatch[1], 10) : null;
    course.length = length;


    if (course) {
      courses.push(course);
    }
  });
  return courses;
}

let counter = 0;

function myTimeout(func, mins) {
  let seconds = Math.floor(mins * 60);
  const intervalId = setInterval(() => {
    if (seconds <= 0) {
      // When time is up, stop the countdown
      clearInterval(intervalId);
      // Execute the user-provided function
      func();
    } else {
      // Print the seconds left
      console.log(`${seconds} second(s) left until timeout.`);
      seconds--;
    }
  }, 1000); // This function runs every 1000ms (1s)
}

async function main() {
  for (const course of findAllCourses()) {
    console.log('Found course:', course.courseItemId, 'Length:', course.length);

    let resp = await trackStart(course);
    counter++;
    console.log("Waiting for course to finish:", course.courseItemId);
    myTimeout(async () => {
      await trackFinish(course, resp.course_work_hist_id);
      counter--;

      if (counter === 0) {
        console.log("All courses finished");
        setTimeout(() => location.reload(), 5000);
      }
    }, (0.5 + course.length));
  }
}

(function() {
    'use strict';

    main();

    // Your code here...
})();
