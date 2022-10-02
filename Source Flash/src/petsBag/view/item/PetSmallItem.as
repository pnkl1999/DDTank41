package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   
   public class PetSmallItem extends Component implements Disposeable
   {
      
      public static const PET_ITEM_WIDTH:int = 78;
       
      
      protected var _bg:DisplayObject;
      
      protected var _info:PetInfo;
      
      protected var _petIcon:BitmapLoaderProxy;
      
      protected var _isFight:Boolean = false;
      
      protected var _fightIcon:Bitmap;
      
      private var _isSelect:Boolean = false;
      
      protected var _shiner:DisplayObject;
      
      public function PetSmallItem(param1:PetInfo = null)
      {
         super();
         this._info = param1;
         this.initView();
         this.initEvent();
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      protected function clickHandler(param1:MouseEvent) : void
      {
         this.selected = !this.selected;
      }
      
      public function get info() : PetInfo
      {
         return this._info;
      }
      
      public function set info(param1:PetInfo) : void
      {
         if(this._petIcon)
         {
            this._petIcon.removeEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__fixPetIconPostion);
            this._petIcon.dispose();
            this._petIcon = null;
         }
         this.isFight = false;
         this._shiner.visible = false;
         this._info = param1;
         if(this._info)
         {
            this._petIcon = new BitmapLoaderProxy(PathManager.solvePetIconUrl(PetBagController.instance().getPicStrByLv(this._info)),null,true);
            this._petIcon.addEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__fixPetIconPostion);
            addChildAt(this._petIcon,2);
            this.isFight = this._info.IsEquip;
         }
      }
      
      private function __fixPetIconPostion(param1:Event) : void
      {
         if(this._petIcon)
         {
            this._petIcon.x = 64 - this._petIcon.width >> 1;
            this._petIcon.y = 59 - this._petIcon.height >> 1;
         }
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("assets.petsBag.petPnlBg");
         addChildAt(this._bg,0);
         this._shiner = ComponentFactory.Instance.creat("petsBag.light");
         addChild(this._shiner);
         this._shiner.visible = false;
         if(this._info)
         {
            this._petIcon = new BitmapLoaderProxy(PathManager.solvePetIconUrl(PetBagController.instance().getPicStrByLv(this._info)),null,true);
            this._petIcon.addEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__fixPetIconPostion);
            addChild(this._petIcon);
            this.isFight = this._info.IsEquip;
         }
         this._fightIcon = ComponentFactory.Instance.creatBitmap("assets.petsBag.fight2");
         addChild(this._fightIcon);
         this._fightIcon.visible = false;
      }
      
      public function set isFight(param1:Boolean) : void
      {
         this._isFight = param1;
         this._fightIcon.visible = this._isFight;
         addChild(this._fightIcon);
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._isSelect = param1;
         this._shiner.visible = this._isSelect;
         dispatchEvent(new Event("selected"));
      }
      
      public function get selected() : Boolean
      {
         return this._isSelect;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(this._shiner)
         {
            ObjectUtils.disposeObject(this._shiner);
            this._shiner = null;
         }
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._petIcon)
         {
            this._petIcon.removeEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__fixPetIconPostion);
            ObjectUtils.disposeObject(this._petIcon);
            this._petIcon = null;
         }
         if(this._fightIcon)
         {
            ObjectUtils.disposeObject(this._fightIcon);
            this._fightIcon = null;
         }
         this._info = null;
         if(this._shiner)
         {
            ObjectUtils.disposeObject(this._shiner);
            this._shiner = null;
         }
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
