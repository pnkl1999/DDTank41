package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class PetsFormItemsTipItem extends Sprite implements Disposeable
   {
       
      
      private var _nameTxt:FilterFrameText;
      
      private var _valueTxt:FilterFrameText;
      
      private var _type:int;
      
      private var _isActive:Boolean;
      
      public function PetsFormItemsTipItem(param1:int)
      {
         super();
         this._type = param1;
         this.initView();
      }
      
      private function initView() : void
      {
         this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.petsTip.valueTxt" + this._type);
         addChild(this._valueTxt);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.petsTip.commonTxt");
         this._nameTxt.text = LanguageMgr.GetTranslation("petsBag.form.petsTips" + this._type);
         addChild(this._nameTxt);
         this._nameTxt.y = this._valueTxt.y;
      }
      
      public function set isActive(param1:Boolean) : void
      {
         this._isActive = param1;
      }
      
      public function set value(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this._type == 1)
         {
            _loc2_ = !!this._isActive ? int(int(this._type + 1)) : int(int(this._type));
            ObjectUtils.disposeObject(this._valueTxt);
            this._valueTxt = null;
            this._valueTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.petsTip.valueTxt" + _loc2_);
            this._valueTxt.x = 72;
            this._valueTxt.y = 40;
            addChild(this._valueTxt);
         }
         this._valueTxt.text = param1;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._valueTxt);
         this._valueTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
