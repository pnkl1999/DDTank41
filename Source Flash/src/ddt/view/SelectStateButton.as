package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SelectStateButton extends Sprite implements Disposeable
   {
       
      
      private var _bg:DisplayObject;
      
      private var _overBg:DisplayObject;
      
      private var _gray:Boolean;
      
      private var _enable:Boolean;
      
      private var _selected:Boolean;
      
      public function SelectStateButton()
      {
         super();
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outHander);
         addEventListener(MouseEvent.CLICK,this.__clickHander);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__outHander);
         removeEventListener(MouseEvent.CLICK,this.__clickHander);
      }
      
      private function __outHander(param1:MouseEvent) : void
      {
         if(this.enable)
         {
            this._bg.visible = !this.selected;
            this._overBg.visible = this.selected;
         }
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
         if(this.enable)
         {
            this._bg.visible = false;
            this._overBg.visible = true;
         }
      }
      
      private function __clickHander(param1:MouseEvent) : void
      {
         if(!this._enable)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         this._bg.visible = !this._selected;
         this._overBg.visible = this._selected;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      public function set enable(param1:Boolean) : void
      {
         this._enable = param1;
      }
      
      public function get gray() : Boolean
      {
         return this._gray;
      }
      
      public function set gray(param1:Boolean) : void
      {
         this._gray = param1;
         if(this._gray)
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            filters = null;
         }
      }
      
      public function set backGround(param1:DisplayObject) : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         this._bg = param1;
         if(this._bg)
         {
            addChild(this._bg);
         }
      }
      
      public function set overBackGround(param1:DisplayObject) : void
      {
         if(this._overBg)
         {
            ObjectUtils.disposeObject(this._overBg);
            this._overBg = null;
         }
         this._overBg = param1;
         if(this._overBg)
         {
            addChild(this._overBg);
         }
      }
      
      public function dispose() : void
      {
      }
   }
}
