package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   
   public class AddPetItem extends Component
   {
       
      
      protected var _bg:DisplayObject;
      
      protected var _info:PetInfo;
      
      protected var _petIcon:PetSmallIcon;
      
      protected var _icon:Bitmap;
      
      protected var _star:StarBar;
      
      public function AddPetItem(param1:PetInfo)
      {
         super();
         this._info = param1;
         this.initView();
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("assets.bag.petPnlBg");
         addChild(this._bg);
         if(this._info)
         {
            this._petIcon = new PetSmallIcon(PetBagController.instance().getPicStrByLv(this._info));
            this._petIcon.addEventListener(Event.COMPLETE,this.__petIconLoadComplete);
            this._petIcon.startLoad();
            this._star = ComponentFactory.Instance.creat("bagAndInfo.starBar.petStar");
            addChild(this._star);
            this._star.starNum(this._info.StarLevel,"assets.bag.star");
         }
      }
      
      protected function __petIconLoadComplete(param1:Event) : void
      {
         this._petIcon.removeEventListener(Event.COMPLETE,this.__petIconLoadComplete);
         this._icon = this._petIcon.icon;
         if(this._icon)
         {
            PositionUtils.setPos(this._icon,"farm.bagAndInfo.iconPos");
            addChild(this._icon);
            this._icon.width = AdoptItem.ADOPT_PET_ITEM_WIDTH;
            this._icon.height = AdoptItem.ADOPT_PET_ITEM_WIDTH;
         }
      }
      
      override public function dispose() : void
      {
         if(this._star)
         {
            ObjectUtils.disposeObject(this._star);
            this._star = null;
         }
         if(this._icon)
         {
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
         }
         if(this._petIcon)
         {
            ObjectUtils.disposeObject(this._petIcon);
            this._petIcon = null;
         }
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         this._info = null;
         super.dispose();
      }
   }
}
