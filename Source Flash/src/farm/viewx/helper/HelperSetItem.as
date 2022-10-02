package farm.viewx.helper
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import farm.view.compose.event.SelectComposeItemEvent;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class HelperSetItem extends Sprite implements Disposeable
   {
       
      
      private var _nameTxt:FilterFrameText;
      
      private var _bgImg:Bitmap;
      
      private var _id:int;
      
      private var _info:ShopItemInfo;
      
      public function HelperSetItem()
      {
         super();
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this._bgImg = ComponentFactory.Instance.creat("asset.farmHouse.selectComposeitemBg");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("core.comboxListCellTxt3");
         this._nameTxt.height = 20;
         addChild(this._nameTxt);
         addChildAt(this._bgImg,0);
         this._bgImg.alpha = 0;
         this._bgImg.width = 100;
         this._bgImg.y = -2;
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.CLICK,this.__click);
         addEventListener(MouseEvent.MOUSE_MOVE,this.__mouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.__mouseOut);
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         this._bgImg.alpha = 1;
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         this._bgImg.alpha = 0;
      }
      
      private function __click(param1:MouseEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.id = this._id;
         var _loc3_:SelectComposeItemEvent = new SelectComposeItemEvent(SelectComposeItemEvent.SELECT_SEED,_loc2_);
         dispatchEvent(_loc3_);
      }
      
      public function set info(param1:ShopItemInfo) : void
      {
         this._nameTxt.text = param1.TemplateInfo.Name;
         this._id = param1.TemplateInfo.TemplateID;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bgImg);
         this._bgImg = null;
         if(this._nameTxt && this._nameTxt.parent)
         {
            this._nameTxt.parent.removeChild(this._nameTxt);
            this._nameTxt = null;
         }
         removeEventListener(MouseEvent.CLICK,this.__click);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
   }
}
