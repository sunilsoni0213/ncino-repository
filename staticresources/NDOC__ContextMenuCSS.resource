/*
 *contextMenu.js v 1.4.0
 *Author: Sudhanshu Yadav
 *s-yadav.github.com
 *Copyright (c) 2013 Sudhanshu Yadav.
 *Dual licensed under the MIT and GPL licenses
 */
/*Context menu css */
.iw-contextMenu {
  -webkit-box-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
  -moz-box-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
  box-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
  border: 1px solid #E6E6E6;
  z-index: 1000;
}
.iw-cm-menu {
  background: white;
  color: #16325c;
  margin: 0px;
  padding: 0px;
}
.iw-cm-menu li {
  list-style: none;
  margin-left: 0px;
  height: 40px;
  padding: 3px;
  padding-left: 10px;
  padding-right: 10px;
  padding-top: 10px;
  border-bottom: 1px solid #CCC;
  cursor: pointer;
  position: relative;
}
.iw-cm-menu li a {
  color: #16325c;
  display: block;
}
.iw-cm-menu li a:hover {
  text-decoration: none;
  color: #F2F2F2;
}
.iw-mOverlay {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0px;
  left: 0px;
  background: #FFF;
  opacity: .5;
}
.iw-contextMenu ul.iw-cm-menu li.iw-disabled-item {
  cursor: not-allowed;
  pointer-events: none;
  color: #D3D3D3;
}
.iw-contextMenu ul.iw-cm-menu li.iw-disabled-item:hover {
  cursor: not-allowed;
  pointer-events: none;
  background: white;
  color: #D3D3D3;
}
.iw-contextMenu ul.iw-cm-menu li.iw-disabled-item a {
  cursor: not-allowed;
  pointer-events: none;
  color: #D3D3D3;
}
.iw-contextMenu ul.iw-cm-menu li.iw-disabled-item a:hover {
  cursor: not-allowed;
  pointer-events: none;
  background: white;
  color: #D3D3D3;
}
.iw-contextMenu li.iw-mDisable {
  opacity: .3;
}
.iw-mSelected {
  background-color: #448AFF;
  color: #F2F2F2;
}
.iw-cm-menu li:hover {
  text-decoration: none;
  background-color: #448AFF;
  color: #F2F2F2;
}
.iw-cm-arrow-right {
  width: 0;
  height: 0;
  border-top: 5px solid transparent;
  border-bottom: 5px solid transparent;
  border-left: 5px solid #333333;
  position: absolute;
  right: 3px;
  top: 50%;
  margin-top: -3px;
}
.iw-mSelected > .iw-cm-arrow-right {
  border-left: 5px solid #FFF;
}
.iw-mIcon {
  width: 20px;
  height: 20px;
  left: 0px;
  top: 3px;
  position: absolute;
}
/*context menu css end */