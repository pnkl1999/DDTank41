package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ConsortionShopItemBtn extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _day:FilterFrameText;
      
      private var _pay:FilterFrameText;
      
      public function ConsortionShopItemBtn()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         buttonMode = true;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortion.shopItem.btn");
         this._day = ComponentFactory.Instance.creatComponentByStylename("consortion.shopItemBtn.day");
         this._pay = ComponentFactory.Instance.creatComponentByStylename("consortion.shopItemBtn.Pay");
         addChild(this._bg);
         addChild(this._day);
         addChild(this._pay);
      }
      
      public function setValue(param1:String, param2:String) : void
      {
         this._day.text = param1;
         this._pay.text = param2;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._day = null;
         this._pay = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
