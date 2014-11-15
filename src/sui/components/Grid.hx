package sui.components;

import dots.Html;
import dots.Query;
import js.html.Element;
import sui.controls.Control;
using thx.core.Arrays;

class Grid {
  public var el(default, null) : Element;

  public function new() {
    el = Html.parse('<table class="sui-grid"></table>');
  }

  public function add(cell : CellContent) switch cell {
    case Single(control):
      var container = Html.parse('<tr class="sui-single"><td colspan="2"></td></tr>');
      Query.first("td", container).appendChild(control.el);
      el.appendChild(container);
    case HorizontalPair(left, right):
      var container = Html.parse('<tr class="sui-horizontal"><td class="sui-left"></td><td class="sui-right"></td></tr>');
      Query.first(".sui-left", container).appendChild(left.el);
      Query.first(".sui-right", container).appendChild(right.el);
      el.appendChild(container);
    case VerticalPair(top, bottom):
      var containers = Html.parseArray('<tr class="sui-vertical sui-top"><td colspan="2"></td></tr><tr class="sui-vertical sui-bottom"><td colspan="2"></td></tr>');
      Query.first("td", containers[0]).appendChild(top.el);
      Query.first("td", containers[1]).appendChild(bottom.el);
      containers.pluck(el.appendChild(_));
  }
}

enum CellContent {
  Single(control : Control<Dynamic>);
  VerticalPair(top : Control<Dynamic>, bottom : Control<Dynamic>);
  HorizontalPair(left : Control<Dynamic>, right : Control<Dynamic>);
}