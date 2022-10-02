package game.actions
{
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import game.view.experience.ExpView;
   import game.view.map.MapView;
   import road7th.comm.PackageIn;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   
   public class GameOverAction extends BaseAction
   {
       
      
      private var _event:CrazyTankSocketEvent;
      
      private var _executed:Boolean;
      
      private var _count:int;
      
      private var _map:MapView;
      
      private var _current:GameInfo;
      
      private var _func:Function;
      
      public function GameOverAction(param1:MapView, param2:CrazyTankSocketEvent, param3:Function, param4:Number = 3000)
      {
         super();
         this._func = param3;
         this._event = param2;
         this._map = param1;
         this._count = param4 / 40;
         this._current = GameManager.Instance.Current;
         this.readInfo(param2);
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._executed = true;
         }
      }
      
      private function readInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Living = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:Player = null;
         if(this._current)
         {
            _loc2_ = param1.pkg;
            _loc3_ = _loc2_.readInt();
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc6_ = _loc2_.readInt();
               _loc7_ = _loc2_.readBoolean();
               _loc8_ = _loc2_.readInt();
               _loc9_ = _loc2_.readInt();
               _loc10_ = {};
               _loc10_.killGP = _loc2_.readInt();
               _loc10_.hertGP = _loc2_.readInt();
               _loc10_.fightGP = _loc2_.readInt();
               _loc10_.ghostGP = _loc2_.readInt();
               _loc10_.gpForVIP = _loc2_.readInt();
               _loc10_.gpForConsortia = _loc2_.readInt();
               _loc10_.gpForSpouse = _loc2_.readInt();
               _loc10_.gpForServer = _loc2_.readInt();
               _loc10_.gpForApprenticeOnline = _loc2_.readInt();
               _loc10_.gpForApprenticeTeam = _loc2_.readInt();
               _loc10_.gpForDoubleCard = _loc2_.readInt();
               _loc10_.gpForPower = _loc2_.readInt();
               _loc10_.consortiaSkill = _loc2_.readInt();
               _loc10_.luckyExp = _loc2_.readInt();
               _loc10_.gainGP = _loc2_.readInt();
               _loc10_.offerFight = _loc2_.readInt();
               _loc10_.offerDoubleCard = _loc2_.readInt();
               _loc10_.offerVIP = _loc2_.readInt();
               _loc10_.offerService = _loc2_.readInt();
               _loc10_.offerBuff = _loc2_.readInt();
               _loc10_.offerConsortia = _loc2_.readInt();
               _loc10_.luckyOffer = _loc2_.readInt();
               _loc10_.gainOffer = _loc2_.readInt();
               _loc10_.canTakeOut = _loc2_.readInt();
               _loc10_.gameOverType = ExpView.GAME_OVER_TYPE_1;
               _loc11_ = this._current.findPlayer(_loc6_);
               if(_loc11_)
               {
                  _loc11_.isWin = _loc7_;
                  _loc11_.CurrentGP = _loc9_;
                  _loc11_.CurrentLevel = _loc8_;
                  _loc11_.expObj = _loc10_;
                  _loc11_.GainGP = _loc10_.gainGP;
                  _loc11_.GainOffer = _loc10_.gainOffer;
                  _loc11_.GetCardCount = _loc10_.canTakeOut;
               }
               _loc4_++;
            }
            this._current.GainRiches = _loc2_.readInt();
            for each(_loc5_ in this._current.livings)
            {
               if(_loc5_.character)
               {
                  _loc5_.character.resetShowBitmapBig();
               }
            }
         }
      }
      
      override public function cancel() : void
      {
         this._event.executed = true;
         this._current = null;
         this._map = null;
         this._event = null;
         this._func = null;
      }
      
      override public function execute() : void
      {
         var _loc1_:MovieClipWrapper = null;
         _loc1_ = null;
         if(!this._executed)
         {
            if(this._map.hasSomethingMoving() == false && (this._map.currentPlayer == null || this._map.currentPlayer.actionCount == 0))
            {
               this._executed = true;
               this._event.executed = true;
               if(this._map.currentPlayer && this._map.currentPlayer.isExist)
               {
                  this._map.currentPlayer.beginNewTurn();
               }
               if(GameManager.Instance.Current.selfGamePlayer.isWin)
               {
                  _loc1_ = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.winAsset")),true,true);
               }
               else
               {
                  _loc1_ = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.lostAsset")),true,true);
               }
               SoundManager.instance.play("040");
               _loc1_.movie.x = 500;
               _loc1_.movie.y = 360;
               this._map.gameView.addChild(_loc1_.movie);
            }
         }
         else
         {
            --this._count;
            if(this._count <= 0)
            {
               this._func();
               _isFinished = true;
               this.cancel();
            }
         }
      }
   }
}
