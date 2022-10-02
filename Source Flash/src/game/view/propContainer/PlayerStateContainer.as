package game.view.propContainer
{
   import bagAndInfo.bag.ItemCellView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.display.BitmapLoaderProxy;
   import ddt.events.LivingEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.view.PropItemView;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import game.model.TurnedLiving;
   import pet.date.PetSkillTemplateInfo;
   
   public class PlayerStateContainer extends SimpleTileList
   {
       
      
      private var _info:TurnedLiving;
      
      public function PlayerStateContainer(param1:Number = 10)
      {
         super(param1);
         hSpace = 6;
         vSpace = 4;
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function get info() : TurnedLiving
      {
         return this._info;
      }
      
      public function set info(param1:TurnedLiving) : void
      {
         if(this._info)
         {
            this._info.removeEventListener(LivingEvent.ADD_STATE,this.__addingState);
            this._info.removeEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
         }
         this._info = param1;
         if(this._info)
         {
            this._info.addEventListener(LivingEvent.ADD_STATE,this.__addingState);
            this._info.addEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
         }
      }
      
      private function __usePetSkill(param1:LivingEvent) : void
      {
         visible = true;
         if(!this._info.isLiving)
         {
            visible = false;
            return;
         }
         var _loc2_:PetSkillTemplateInfo = PetSkillManager.getSkillByID(param1.value);
         if(_loc2_ && _loc2_.isActiveSkill)
         {
            addChild(new ItemCellView(0,new BitmapLoaderProxy(PathManager.solveSkillPicUrl(_loc2_.Pic),new Rectangle(0,0,40,40))));
         }
      }
      
      private function __addingState(param1:LivingEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Bitmap = null;
         if(visible == false)
         {
            visible = true;
         }
         if(!this._info.isLiving)
         {
            visible = false;
            return;
         }
         if(param1.value > 0)
         {
            _loc2_ = new InventoryItemInfo();
            _loc2_.TemplateID = param1.value;
            ItemManager.fill(_loc2_);
            if(_loc2_.CategoryID != EquipType.OFFHAND && _loc2_.CategoryID != EquipType.TEMP_OFFHAND)
            {
               addChild(new ItemCellView(0,PropItemView.createView(_loc2_.Pic,40,40)));
            }
            else
            {
               _loc3_ = PlayerManager.Instance.getDeputyWeaponIcon(_loc2_,1);
               addChild(new ItemCellView(0,_loc3_));
            }
         }
         else if(param1.value == -1)
         {
            _loc4_ = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.specialKillAsset");
            _loc4_.width = 40;
            _loc4_.height = 40;
            addChild(new ItemCellView(0,_loc4_));
         }
         else if(param1.value == -2)
         {
            addChild(new ItemCellView(0,PropItemView.createView(param1.paras[0],40,40)));
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
