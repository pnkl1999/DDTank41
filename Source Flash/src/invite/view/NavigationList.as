package invite.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class NavigationList extends Sprite implements Disposeable
   {
       
      
      private var _type:int;
      
      private var _modeArr:Array;
      
      private var _buttons:Array;
      
      private var _list:ListPanel;
      
      private var _listBack:DisplayObject;
      
      private var _listArr:Array;
      
      public function NavigationList()
      {
         super();
         this.configUI();
      }
      
      private function configUI() : void
      {
         this._listBack = ComponentFactory.Instance.creatComponentByStylename("invite.list.BackgroundList");
         addChild(this._listBack);
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
      }
      
      public function get list() : Array
      {
         return this._listArr;
      }
      
      public function set list(param1:Array) : void
      {
      }
      
      public function get mode() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < this._modeArr.length)
         {
            _loc1_ += this._modeArr[_loc2_] + ",";
            _loc2_++;
         }
         return _loc1_.substr(0,_loc1_.length - 1);
      }
      
      public function set mode(param1:String) : void
      {
         this._modeArr = param1.split(",");
      }
      
      public function addNavButton(param1:NavButton, param2:int) : void
      {
         var _loc3_:ButtonProxy = new ButtonProxy();
         _loc3_.button = param1;
         _loc3_.type = param2;
         this._buttons.push(_loc3_);
      }
      
      private function setNavigationPos(param1:int) : void
      {
      }
      
      public function dispose() : void
      {
      }
   }
}

import invite.view.NavButton;

class ButtonProxy
{
    
   
   public var button:NavButton;
   
   public var type:int;
   
   function ButtonProxy()
   {
      super();
   }
}
