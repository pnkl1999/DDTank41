package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class BuildingLevelItem extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      private var _type:int = 0;
      
      private var _tipData:Object;
      
      private var _background:Bitmap;
      
      private var _level:FilterFrameText;
      
      public function BuildingLevelItem(param1:int)
      {
         super();
         this._type = param1;
         this.initView();
      }
      
      private function initView() : void
      {
         ShowTipManager.Instance.addTip(this);
         switch(this._type)
         {
            case ConsortionModel.SHOP:
               this._background = ComponentFactory.Instance.creatBitmap("asset.consortion.shop");
               break;
            case ConsortionModel.STORE:
               this._background = ComponentFactory.Instance.creatBitmap("asset.consortion.store");
               break;
            case ConsortionModel.BANK:
               this._background = ComponentFactory.Instance.creatBitmap("asset.consortion.bank");
               break;
            case ConsortionModel.SKILL:
               this._background = ComponentFactory.Instance.creatBitmap("asset.consortion.skill");
         }
         this._level = ComponentFactory.Instance.creatComponentByStylename("consortion.buildLevel");
         addChild(this._background);
         addChild(this._level);
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = ConsortionModelControl.Instance.model.getLevelString(this._type,param1 as int);
         this._level.text = "Lv." + param1;
      }
      
      public function get tipDirctions() : String
      {
         return "3";
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return 0;
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 0;
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return "consortion.ConsortiaLevelTip";
      }
      
      public function set tipStyle(param1:String) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeAllChildren(this);
         this._background = null;
         this._level = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
