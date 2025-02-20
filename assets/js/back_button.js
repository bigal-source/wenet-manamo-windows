addAnother = function() {
    var ul = document.getElementsByTagName("left")[0];
    var li = document.createElement("a");
    var span1 = document.createElement("span");
        span1.setAttribute("style", "font-size:14px")
        span1.setAttribute("id", "proccess")
        span1.appendChild(document.createTextNode(""))

    var a1 = document.createElement("a");
        a1.setAttribute("class", "view-icon-link goViewBack top-view-icon-only")
    li.setAttribute("id", "element4")
    li.setAttribute("class", "tool-button")
    var div1 = document.createElement("div");
        div1.setAttribute("class", "view-item-block-content")
    var div2 = document.createElement("div");
        div2.setAttribute("class", "view-item-block-media")
    var i1 = document.createElement("i");
        i1.setAttribute("class", "icon-view-download-book icon-font-size-em1-8")
    div2.appendChild(i1);
    var div3 = document.createElement("div");
        div3.setAttribute("class", "view-item-block-inner")

    var div4 = document.createElement("div");
        div4.setAttribute("id", "view-dowload-id")
        div4.setAttribute("class", "view-item-block-title")
        div4.appendChild(document.createTextNode("ダウンロード"))
        div4.appendChild(span1)
    div3.appendChild(div4);
    div1.appendChild(div2);
    div1.appendChild(div3);
    a1.appendChild(div1);
    li.appendChild(a1);
    ul.appendChild(li);
    return ul;
}
addAnother();
var counter = 0;
window.bookData = function booData(aa) {
  console.log(aa);
};
