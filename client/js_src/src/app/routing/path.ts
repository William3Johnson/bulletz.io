
function parseQuery(queryString) {
    if (queryString == "") {
      return {};
    }
    const query = {};
    const pairs = (queryString[0] === "?" ? queryString.substr(1) : queryString).split("&");
    for (const pair_text of pairs) {
        const pair = pair_text.split("=");
        query[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1] || "");
    }
    return query;
}

function queryParams() {
  return parseQuery(window.location.search);
}

function pathname() {
  return window.location.pathname;
}

export {queryParams, pathname};
