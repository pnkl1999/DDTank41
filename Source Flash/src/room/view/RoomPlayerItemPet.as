package room.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.PathManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   
   public class RoomPlayerItemPet extends Sprite implements Disposeable
   {
       
      
      private var _petLevel:FilterFrameText;
      
      private var _petInfo:PetInfo;
      
      private var _headPetWidth:Number;
      
      private var _headPetHight:Number;
      
      private var _excursion:Number = 3;
      
      private var _icons:Dictionary;
      
      public function RoomPlayerItemPet(param1:Number = 0, param2:Number = 0)
      {
         super();
         this._headPetWidth = param1;
         this._headPetHight = param2;
         this._icons = new Dictionary();
         this._petLevel = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.playerItem.petLevelTxt");
         addChild(this._petLevel);
      }
      
      private function createPetIcon() : void
      {
         var _loc1_:BitmapLoaderProxy = new BitmapLoaderProxy(PathManager.solvePetIconUrl(PetBagController.instance().getPicStrByLv(this._petInfo)),null,true);
         _loc1_.addEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__iconLoadingFinish);
         this._icons[this._petInfo.ID] = _loc1_;
      }
      
      public function updateView(param1:PetInfo) : void
      {
         this._petInfo = param1;
         this.iconvisible();
         if(this._petInfo)
         {
            if(this._icons[this._petInfo.ID])
            {
               this._icons[this._petInfo.ID].visible = true;
            }
            else
            {
               this.createPetIcon();
            }
            this._petLevel.text = "LV:" + this._petInfo.Level;
         }
         else
         {
            this._petLevel.text = "";
         }
      }
      
      private function iconvisible() : void
      {
         var _loc1_:BitmapLoaderProxy = null;
         for each(_loc1_ in this._icons)
         {
            if(_loc1_)
            {
               _loc1_.visible = false;
            }
         }
      }
      
      private function __iconLoadingFinish(param1:Event) : void
      {
         var _loc2_:BitmapLoaderProxy = null;
         _loc2_ = null;
         _loc2_ = param1.target as BitmapLoaderProxy;
         _loc2_.removeEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__iconLoadingFinish);
         _loc2_.scaleX = 0.7;
         _loc2_.scaleY = 0.7;
         _loc2_.x = (this._headPetWidth - _loc2_.width) / 2 + this._excursion;
         _loc2_.y = (this._headPetHight - _loc2_.height) / 2;
         addChildAt(_loc2_,0);
         this._petLevel.x = _loc2_.x + (_loc2_.width - this._petLevel.width) / 2;
         this._petLevel.y = this._headPetHight - this._petLevel.height;
      }
      
      public function dispose() : void
      {
         var _loc1_:BitmapLoaderProxy = null;
         if(this._petLevel)
         {
            ObjectUtils.disposeObject(this._petLevel);
         }
         this._petLevel = null;
         for each(_loc1_ in this._icons)
         {
            if(_loc1_)
            {
               ObjectUtils.disposeObject(_loc1_);
            }
            _loc1_ = null;
         }
         this._icons = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
