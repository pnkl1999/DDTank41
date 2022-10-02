package game.view.playerThumbnail
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.events.LivingEvent;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import game.model.Living;
   import game.model.SimpleBoss;
   
   import room.model.RoomInfo;
   import room.RoomManager;
   import worldboss.WorldBossManager;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.view.WorldBossCutHpMC;
   
   public class BossThumbnail extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _living:Living;
      
      private var _headFigure:HeadFigure;
      
      private var _blood:BossBloodItem;
      
      private var _name:FilterFrameText;
      
      private var lightingFilter:BitmapFilter;
      
      public function BossThumbnail(param1:Living)
      {
         super();
         this._living = param1;
         this.init();
         this.initEvents();
      }
      
      public function init() : void
      {
         var _loc1_:Point = null;
         _loc1_ = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.bossThumbnailBgAsset");
         addChild(this._bg);
         this._headFigure = new HeadFigure(62,62,this._living);
         addChild(this._headFigure);
         this._headFigure.y = 11;
         this._headFigure.x = 4;
		 if(RoomManager.Instance.current.type == RoomInfo.WORLD_BOSS_FIGHT)
		 {
			 this._blood = new BossBloodItem(WorldBossManager.Instance.bossInfo.total_Blood);
			 WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.BOSS_HP_UPDATA,this.__showCutHp);
			 this._blood.bloodNum = WorldBossManager.Instance.bossInfo.current_Blood;
		 }
		 else
		 {
			 this._blood = new BossBloodItem(this._living.maxBlood);
			 this.__updateBlood(null);
		 }
         addChild(this._blood);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("room.bossThumbnailHPPos");
         this._blood.x = _loc1_.x;
         this._blood.y = _loc1_.y;
         this._name = ComponentFactory.Instance.creatComponentByStylename("asset.game.bossThumbnailNameTxt");
         addChild(this._name);
         this._name.text = this._living.name;
      }
	  
	  import ddt.utils.PositionUtils;
	  private function __showCutHp(param1:WorldBossRoomEvent) : void
	  {
		  if(WorldBossManager.Instance.bossInfo.cutValue <= 0)
		  {
			  return;
		  }
		  if(this._blood)
		  {
			  this._blood.updateBlood(WorldBossManager.Instance.bossInfo.current_Blood,WorldBossManager.Instance.bossInfo.total_Blood);
		  }
		  var _loc2_:WorldBossCutHpMC = new WorldBossCutHpMC(WorldBossManager.Instance.bossInfo.cutValue);
		  PositionUtils.setPos(_loc2_,"fightBoss.numMC.pos");
		  addChildAt(_loc2_,0);
	  }
      
      public function initEvents() : void
      {
         if(this._living)
         {
            this._living.addEventListener(LivingEvent.BLOOD_CHANGED,this.__updateBlood);
            this._living.addEventListener(LivingEvent.DIE,this.__die);
         }
      }
      
      public function __updateBlood(param1:LivingEvent) : void
      {
         this._blood.bloodNum = this._living.blood;
         if(this._living.blood <= 0)
         {
            if(this._headFigure)
            {
               this._headFigure.gray();
            }
         }
      }
      
      public function __die(param1:LivingEvent) : void
      {
         if(this._headFigure)
         {
            this._headFigure.gray();
         }
         if(this._blood)
         {
            this._blood.visible = false;
         }
      }
      
      private function __shineChange(param1:LivingEvent) : void
      {
         var _loc2_:SimpleBoss = this._living as SimpleBoss;
         if(_loc2_ && _loc2_.isAttacking)
         {
         }
      }
      
      public function setUpLintingFilter() : void
      {
         var _loc1_:Array = new Array();
         _loc1_ = _loc1_.concat([1,0,0,0,25]);
         _loc1_ = _loc1_.concat([0,1,0,0,25]);
         _loc1_ = _loc1_.concat([0,0,1,0,25]);
         _loc1_ = _loc1_.concat([0,0,0,1,0]);
         this.lightingFilter = new ColorMatrixFilter(_loc1_);
      }
      
      public function removeEvents() : void
      {
         if(this._living)
         {
            this._living.removeEventListener(LivingEvent.BLOOD_CHANGED,this.__updateBlood);
            this._living.removeEventListener(LivingEvent.DIE,this.__die);
         }
      }
      
      public function updateView() : void
      {
         if(!this._living)
         {
            this.visible = false;
         }
         else
         {
            if(this._headFigure)
            {
               this._headFigure.dispose();
               this._headFigure = null;
            }
            if(this._blood)
            {
               this._blood = null;
            }
            this.init();
         }
      }
      
      public function set info(param1:Living) : void
      {
         if(!param1)
         {
            this.removeEvents();
         }
         this._living = param1;
         this.updateView();
      }
      
      public function get Id() : int
      {
         if(!this._living)
         {
            return -1;
         }
         return this._living.LivingID;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         this._living = null;
         this._headFigure.dispose();
         this._headFigure = null;
         this._blood.dispose();
         this._blood = null;
         this._name.dispose();
         this._name = null;
         this.lightingFilter = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
