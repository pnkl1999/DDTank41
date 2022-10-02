package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import worldboss.WorldBossManager;
   
   public class WorldBossHPScript extends Sprite implements Disposeable
   {
       
      
      private var _bloodStrip:MovieClip;
      
      private var _bloodWidth:int;
      
      private var _hp_text:TextField;
      
      private var _bossName_text:TextField;
      
      private var _scale:Number;
      
      private var _iscuting:Boolean;
      
      private var speed:Number = 1.0;
      
      public function WorldBossHPScript()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._bloodStrip = ComponentFactory.Instance.creat("tank.worldboss.hpscript-" + WorldBossManager.Instance.BossResourceId);
         addChild(this._bloodStrip);
         this._bossName_text = this._bloodStrip["boss_name"]["value_text"];
         this._bossName_text.text = WorldBossManager.Instance.bossInfo.name;
         this._hp_text = this._bloodStrip["boss_hp"]["value_text"];
         this.refreshBlood();
      }
      
      public function refreshBossName() : void
      {
         this._bossName_text.text = WorldBossManager.Instance.bossInfo.name;
      }
      
      public function refreshBlood() : void
      {
         this.showBloodText();
         this._bloodStrip["red2_hp"].stop();
         this._scale = this._bloodStrip["red_hp"]["red_mask"].width / WorldBossManager.Instance.bossInfo.total_Blood;
         this._bloodStrip["red_hp"]["red_mask"].x = -1 * this._scale * (WorldBossManager.Instance.bossInfo.total_Blood - WorldBossManager.Instance.bossInfo.current_Blood) - 1;
         this._bloodStrip["red2_hp"]["red2_mask"].x = this._bloodStrip["red_hp"]["red_mask"].x;
      }
      
      private function addEvent() : void
      {
         WorldBossManager.Instance.bossInfo.addEventListener(Event.CHANGE,this.updateBloodStrip);
      }
      
      private function showBloodText() : void
      {
         if(WorldBossManager.Instance.isAutoBlood)
         {
            this._hp_text.text = "?????";
         }
         else
         {
            this._hp_text.text = WorldBossManager.Instance.bossInfo.current_Blood + "/" + WorldBossManager.Instance.bossInfo.total_Blood;
         }
      }
      
      private function updateBloodStrip(param1:Event) : void
      {
         this.refreshBlood();
         this.playCutHpMC(WorldBossManager.Instance.bossInfo.total_Blood - WorldBossManager.Instance.bossInfo.current_Blood);
         if(StateManager.currentStateType == StateType.WORLDBOSS_ROOM)
         {
            this.__showCutHp();
         }
      }
      
      private function playCutHpMC(param1:Number) : void
      {
         this._bloodStrip["red_hp"]["red_mask"].x = -1 * this._scale * param1 - 1;
         if(!this._iscuting)
         {
            this._iscuting = true;
            addEventListener(Event.ENTER_FRAME,this.cutHpred2);
         }
      }
      
      private function cutHpred2(param1:Event) : void
      {
         if(!this._bloodStrip || !this._bloodStrip["red_hp"]["red_mask"] || !this._bloodStrip["red2_hp"]["red2_mask"])
         {
            return;
         }
         if(this._bloodStrip["red_hp"]["red_mask"].x >= this._bloodStrip["red2_hp"]["red2_mask"].x)
         {
            removeEventListener(Event.ENTER_FRAME,this.cutHpred2);
            this._bloodStrip["red2_hp"]["red2_mask"].x = this._bloodStrip["red_hp"]["red_mask"].x;
            this._iscuting = false;
         }
         else
         {
            this._bloodStrip["red2_hp"]["red2_mask"].x -= this.speed;
         }
      }
      
      private function __showCutHp() : void
      {
         var _loc1_:WorldBossCutHpMC = new WorldBossCutHpMC(WorldBossManager.Instance.bossInfo.cutValue);
         PositionUtils.setPos(_loc1_,"worldboss.numMC.pos");
         addChildAt(_loc1_,0);
      }
      
      private function offset(param1:int = 30) : int
      {
         var _loc2_:int = int(Math.random() * 10);
         if(_loc2_ % 2 == 0)
         {
            return -int(Math.random() * param1);
         }
         return int(Math.random() * param1);
      }
      
      public function dispose() : void
      {
         WorldBossManager.Instance.bossInfo.removeEventListener(Event.CHANGE,this.updateBloodStrip);
         if(this._bloodStrip)
         {
            removeChild(this._bloodStrip);
         }
         this._bloodStrip = null;
         this._bossName_text = null;
         this._hp_text = null;
      }
   }
}
