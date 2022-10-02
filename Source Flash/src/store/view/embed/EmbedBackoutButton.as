package store.view.embed
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.interfaces.IDragable;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class EmbedBackoutButton extends Sprite implements IDragable
   {
       
      
      private var _enabel:Boolean;
      
      private var _dragTarget:EmbedStoneCell;
      
      private var myColorMatrix_filter:ColorMatrixFilter;
      
      private var lightingFilter:ColorMatrixFilter;
      
      public var isAction:Boolean;
      
      public function EmbedBackoutButton()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.store.embedBackoutBtn");
         addChild(_loc1_);
         buttonMode = true;
         this.addEvent();
         this.myColorMatrix_filter = ComponentFactory.Instance.creatFilters("store.myColorFilter")[0];
         this.lightingFilter = ComponentFactory.Instance.creatFilters("store.lightFilter")[0];
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         this.filters = [this.lightingFilter];
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         this.filters = null;
      }
      
      public function dragStop(param1:DragEffect) : void
      {
         this.mouseEnabled = true;
         this.isAction = false;
      }
      
      public function set enable(param1:Boolean) : void
      {
         this._enabel = param1;
         buttonMode = param1;
         if(param1)
         {
            this.addEvent();
            this.filters = null;
         }
         else
         {
            this.removeEvent();
            this.filters = [this.myColorMatrix_filter];
         }
      }
      
      public function get enable() : Boolean
      {
         return this._enabel;
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function getDragData() : Object
      {
         return this;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._dragTarget)
         {
            ObjectUtils.disposeObject(this._dragTarget);
         }
         this._dragTarget = null;
         this.lightingFilter = null;
         this.myColorMatrix_filter = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
