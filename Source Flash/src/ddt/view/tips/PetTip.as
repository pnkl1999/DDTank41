package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class PetTip extends BaseTip
   {
      
      private static const PET_ICON_SIZE:int = 35;
       
      
      private var _petName:FilterFrameText;
      
      private var _petIcon:BitmapLoaderProxy;
      
      private var _petIconContainer:Sprite;
      
      private var _petLevel:FilterFrameText;
      
      private var _bg:Image;
      
      public function PetTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._petName = ComponentFactory.Instance.creatComponentByStylename("petTip.PetName");
         this._petLevel = ComponentFactory.Instance.creatComponentByStylename("petTip.PetLevel");
         this._petIconContainer = new Sprite();
         PositionUtils.setPos(this._petIconContainer,"petTip.PetIconPos");
         super.init();
         super.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._petName);
         addChild(this._petLevel);
         addChild(this._petIconContainer);
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(param1)
         {
            if(this._petIcon)
            {
               ObjectUtils.disposeObject(this._petIcon);
            }
            _tipData = param1;
            this._petName.text = String(param1["petName"]);
            this._petLevel.text = "Lv." + String(param1["petLevel"]);
            this._petIcon = new BitmapLoaderProxy(PathManager.solvePetIconUrl(String(param1["petIconUrl"])),new Rectangle(0,0,PET_ICON_SIZE,PET_ICON_SIZE),true);
            this._petIconContainer.addChild(this._petIcon);
            this.updateWH();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._petName);
         this._petName = null;
         ObjectUtils.disposeObject(this._petLevel);
         this._petLevel = null;
         ObjectUtils.disposeObject(this._petIcon);
         this._petIcon = null;
         ObjectUtils.disposeObject(this._petIconContainer);
         this._petIconContainer = null;
      }
      
      private function updateWH() : void
      {
         this._bg.width = width = 170;
         this._bg.height = height = 70;
      }
   }
}
