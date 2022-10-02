package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class TotemSignTxtCell extends Sprite implements Disposeable
   {
      
      public static const TOTEM_SIGN:int = 201084;
       
      
      private var _iconComponent:Component;
      
      private var _icon:Bitmap;
      
      private var _txt:FilterFrameText;
      
      public function TotemSignTxtCell()
      {
         super();
         this._icon = ComponentFactory.Instance.creatBitmap("asset.totem.totemSignIcon");
         this._iconComponent = ComponentFactory.Instance.creatCustomObject("totemSign.cellTipComponent");
         this._iconComponent.tipData = LanguageMgr.GetTranslation("ddt.totem.rightViewTotemSignTipMsg");
         this._iconComponent.addChild(this._icon);
         addChild(this._iconComponent);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.totemSignTxtCelltotemTxt");
         addChild(this._txt);
      }
      
      public function updateData() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(TOTEM_SIGN,true);
         this._txt.text = _loc1_ + "";
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         ObjectUtils.disposeAllChildren(this._iconComponent);
         ObjectUtils.disposeObject(this._iconComponent);
         this._iconComponent = null;
         ObjectUtils.disposeObject(this._txt);
         this._txt = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
