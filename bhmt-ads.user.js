// ==UserScript==
// @name         BHMT ADs Manager
// @namespace    http://tampermonkey.net/
// @version      2025-05-06
// @description  BHMT ADs Manager
// @author       lihe07
// @match        https://ani.gamer.com.tw/animeVideo.php?sn=*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=ani.gamer.com.tw
// @grant        none
// @version      0.1
// @run-at       document-idle
// ==/UserScript==

function getVideoSnList() {
    let result = [];
    document.querySelectorAll(".season li>a[data-ani-video-sn]").forEach(e => result.push(e.getAttribute("data-ani-video-sn")));
    return result;
}

async function checkAdUnlock(sn) {
    const deviceId = localStorage.getItem("ANIME_deviceid");
    const resp = await fetch(`https://ani.gamer.com.tw/ajax/token.php?adID=undefined&sn=${sn}&device=${deviceId}`)
    const data = await resp.json();
    return data.time == 1;
}

async function adStart(ad, sn) {
    await fetch(`https://ani.gamer.com.tw/ajax/videoCastcishu.php?s=${ad}&sn=${sn}`);
    let t = 30;
    let interval = setInterval(() => {
        t--;
        setText(sn, t + "s");
        if (t <= 0) {
            clearInterval(interval);
            adEnd(ad, sn);
        }
    }, 1000);
}

async function adEnd(ad, sn) {
    await fetch(`https://ani.gamer.com.tw/ajax/videoCastcishu.php?s=${ad}&sn=${sn}&ad=end`);
    setText(sn, "OK");

    // if (isCurrentPage(sn)) {
    //    alert("Current Ads state changed! Refreshing...");
    //    location.reload();
    // }
}

function setText(sn, text) {
    const a = document.querySelector(`.season li>a[data-ani-video-sn="${sn}"]`)
    a.parentNode.style = "height: max-content;";
    if (!a.querySelector("div")) {
        a.appendChild(document.createElement("div"));
    }
    a.querySelector("div").innerText = text;
}

function isCurrentPage(sn) {
    const a = document.querySelector(`.season li>a[data-ani-video-sn="${sn}"]`)
    return a.parentNode.classList.contains("playing");
}

async function checkAdsAll() {
    const snList = getVideoSnList();
    const adId = getMajorAd()[2];
    for (const s of snList) {
        if (await checkAdUnlock(s)) {
            setText(s, "OK");
        } else {
            await adStart(adId, s);
        }
    }
}

(function() {
    'use strict';
    console.log("== BHMT Ads Mgr Loaded ==");

    checkAdsAll();

    setInterval(checkAdsAll, 5 * 60 * 1000); // Check every 5 min
})();
