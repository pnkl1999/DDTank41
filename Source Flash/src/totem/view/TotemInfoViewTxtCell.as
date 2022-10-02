package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import totem.TotemManager;
   import totem.data.TotemAddInfo;
   
   public class TotemInfoViewTxtCell extends Sprite implements Disposeable
   {
       
      
      private var _nameTxt:FilterFrameText;
      
      private var _valueTxt:FilterFrameText;
      
      private var _txtArray:Array;
      
      private var _bg:Bitmap;
      
      public function TotemInfoViewTxtCell()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.infoView.txtCellBg");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.infoView.propertyName.txt");
         this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("totem.infoView.propertyValue.txt");
         var _loc1_:String = LanguageMgr.GetTranslation("ddt.totem.sevenProperty");
         this._txtArray = _loc1_.split(",");
         addChild(this._bg);
         addChild(this._nameTxt);
         addChild(this._valueTxt);
      }
      
      public function show(param1:int, param2:int) : void
      {
         this._nameTxt.text = this._txtArray[param1 - 1];
         if(this._nameTxt.numLines == 1)
         {
            this._nameTxt.y = 2;
         }
         var _loc3_:TotemAddInfo = TotemManager.instance.getAddInfo(param2);
         switch(param1)
         {
            case 1:
               this._valueTxt.text = _loc3_.Attack.toString();
               break;
            case 2:
               this._valueTxt.text = _loc3_.Defence.toString();
               break;
            case 3:
               this._valueTxt.text = _loc3_.Agility.toString();
               break;
            case 4:
               this._valueTxt.text = _loc3_.Luck.toString();
               break;
            case 5:
               this._valueTxt.text = _loc3_.Blood.toString();
               break;
            case 6:
               this._valueTxt.text = _loc3_.Damage.toString();
               break;
            case 7:
               this._valueTxt.text = _loc3_.Guard.toString();
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._nameTxt = null;
         this._valueTxt = null;
         this._bg = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
