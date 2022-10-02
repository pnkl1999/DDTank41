package auctionHouse.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.CateCoryInfo;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BrowseLeftMenuItem extends Sprite implements Disposeable, IMenuItem
   {
       
      
      private var accect:BrowserLeftStripAsset;
      
      private var _info:CateCoryInfo;
      
      private var _isOpen:Boolean = false;
      
      private var _hasIcon:Boolean;
      
      private var _hideIcon:Boolean;
      
      public function BrowseLeftMenuItem(param1:BrowserLeftStripAsset, param2:CateCoryInfo, param3:Boolean = false)
      {
         super();
         this.accect = param1;
         this._info = param2;
         this._hideIcon = param3;
         buttonMode = true;
         addChild(this.accect);
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this.accect.addEventListener(MouseEvent.CLICK,this.btnClickHandler);
         this.addRollEvent();
         if(this.accect.icon)
         {
            this._hasIcon = true;
            if(this._hideIcon)
            {
               this.accect.icon.visible = false;
            }
            this.accect.icon.setFrame(1);
         }
      }
      
      public function dispose() : void
      {
         if(this.accect)
         {
            this.removeRollEvent();
            ObjectUtils.disposeObject(this.accect);
         }
         this.accect = null;
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function removeRollEvent() : void
      {
         this.accect.removeEventListener(MouseEvent.CLICK,this.btnClickHandler);
         this.accect.removeEventListener(MouseEvent.ROLL_OVER,this.btnClickHandler);
         this.accect.removeEventListener(MouseEvent.ROLL_OUT,this.btnClickHandler);
      }
      
      private function addRollEvent() : void
      {
         this.accect.addEventListener(MouseEvent.ROLL_OVER,this.btnClickHandler);
         this.accect.addEventListener(MouseEvent.ROLL_OUT,this.btnClickHandler);
      }
      
      private function initView() : void
      {
         this.accect.type_txt.text = this._info.Name;
         this.accect.type_text = this._info.Name;
      }
      
      public function get info() : Object
      {
         return this._info;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function set isOpen(param1:Boolean) : void
      {
         this._isOpen = param1;
         if(this._isOpen && this._hasIcon)
         {
            this.accect.icon.setFrame(2);
         }
         else if(!this._isOpen && this._hasIcon)
         {
            this.accect.icon.setFrame(1);
         }
      }
      
      public function set enable(param1:Boolean) : void
      {
         if(param1)
         {
            this.accect.bg.setFrame(1);
            this.addRollEvent();
         }
         else
         {
            this.accect.bg.setFrame(2);
            this.removeRollEvent();
         }
      }
      
      private function btnClickHandler(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.CLICK:
               this.accect.bg.setFrame(2);
               break;
            case MouseEvent.ROLL_OVER:
               this.accect.bg.setFrame(2);
               break;
            case MouseEvent.ROLL_OUT:
               this.accect.bg.setFrame(1);
         }
      }
   }
}
