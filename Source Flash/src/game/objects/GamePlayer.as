package game.objects
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.PlayerAction;
   import ddt.data.EquipType;
   import ddt.data.FightBuffInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.utils.Helpers;
   import ddt.utils.PositionUtils;
   import ddt.view.ExpMovie;
   import ddt.view.FaceContainer;
   import ddt.view.character.GameCharacter;
   import ddt.view.character.ShowCharacter;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import ddt.view.common.DailyLeagueLevel;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.actions.GhostMoveAction;
   import game.actions.PlayerBeatAction;
   import game.actions.PlayerFallingAction;
   import game.actions.PlayerWalkAction;
   import game.actions.PrepareShootAction;
   import game.actions.SelfSkipAction;
   import game.actions.ShootBombAction;
   import game.actions.SkillActions.ResolveHurtAction;
   import game.actions.SkillActions.RevertAction;
   import game.animations.AnimationLevel;
   import game.animations.BaseSetCenterAnimation;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import newTitle.NewTitleManager;
   import pet.date.PetSkillTemplateInfo;
   import phy.maps.Map;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.StringObject;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class GamePlayer extends GameTurnedLiving
   {
       
      
      protected var _player:Sprite;
      
      protected var _attackPlayerCite:MovieClip;
      
      private var _levelIcon:LevelIcon;
      
      private var _leagueRank:DailyLeagueLevel;
      
      protected var _consortiaName:FilterFrameText;
      
      private var _facecontainer:FaceContainer;
      
      private var _ballpos:Point;
      
      private var _expView:ExpMovie;
      
      private var _resolveHurtMovie:MovieClipWrapper;
      
      private var _currentPetSkill:PetSkillTemplateInfo;
      
      private var _petMovie:GamePetMovie;
      
      public var UsedPetSkill:DictionaryData;
      
      private var _danderFire:MovieClip;
      
      public var isShootPrepared:Boolean;
      
      private var _character:ShowCharacter;
      
      private var _body:GameCharacter;
      
      private var _weaponMovie:MovieClip;
      
      private var _currentWeaponMovie:MovieClip;
      
      private var _currentWeaponMovieAction:String = "";
      
      private var _tomb:TombView;
      
      private var labelMapping:Dictionary;
      
      private var _newTitle:Bitmap;
      
      public function GamePlayer(_arg_1:Player, _arg_2:ShowCharacter, _arg_3:GameCharacter = null)
      {
         this.UsedPetSkill = new DictionaryData();
         this.labelMapping = new Dictionary();
         this._character = _arg_2;
         this._body = _arg_3;
         super(_arg_1);
         this.initBuff();
         this._ballpos = new Point(30,-20);
         if(_arg_1.currentPet)
         {
            this._petMovie = new GamePetMovie(_arg_1.currentPet.petInfo,this);
            this._petMovie.addEventListener(GamePetMovie.PlayEffect,this.__playPlayerEffect);
         }
      }
      
      protected function __playPlayerEffect(_arg_1:Event) : void
      {
         if(ModuleLoader.hasDefinition(this._currentPetSkill.EffectClassLink))
         {
            this.showEffect(this._currentPetSkill.EffectClassLink);
         }
      }
      
      public function get facecontainer() : FaceContainer
      {
         return this._facecontainer;
      }
      
      public function set facecontainer(_arg_1:FaceContainer) : void
      {
         this._facecontainer = _arg_1;
      }
      
      override protected function initView() : void
      {
         var _local_1:GameInfo = null;
         var _local_2:SelfInfo = null;
         var _loc33_:* = null;
         var _loc22_:* = null;
         bodyHeight = 55;
         super.initView();
         this._player = new Sprite();
         this._player.y = -3;
         addChild(this._player);
         _nickName.x = -19;
         this._body.x = 0;
         this._body.doAction(this.getAction("stand"));
         this._player.addChild(this._body as DisplayObject);
         this._player.mouseChildren = this._player.mouseEnabled = false;
         _chatballview = new ChatBallPlayer();
         this._attackPlayerCite = ClassUtils.CreatInstance("asset.game.AttackCiteAsset") as MovieClip;
         this._attackPlayerCite.y = -75;
         this._attackPlayerCite.mouseChildren = this._attackPlayerCite.mouseEnabled = false;
         if(this.player.isAttacking && !RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._attackPlayerCite.gotoAndStop(_info.team);
            removeChild(this._attackPlayerCite);
         }
         if(RoomManager.Instance.current.isLeagueRoom)
         {
            this._leagueRank = new DailyLeagueLevel();
            this._leagueRank.size = DailyLeagueLevel.SIZE_SMALL;
            this._leagueRank.leagueFirst = this.player.playerInfo.DailyLeagueFirst;
            this._leagueRank.score = this.player.playerInfo.DailyLeagueLastScore;
            PositionUtils.setPos(this._leagueRank,"game.gamePlayer.leagueRankPos");
            addChild(this._leagueRank);
         }
         else
         {
            this._levelIcon = new LevelIcon();
            this._levelIcon.setInfo(this.player.playerInfo.Grade,this.player.playerInfo.Repute,this.player.playerInfo.WinCount,this.player.playerInfo.TotalCount,this.player.playerInfo.FightPower,this.player.playerInfo.Offer,true);
            this._levelIcon.setSize(LevelIcon.SIZE_BIG);
            this._levelIcon.x = -52;
            this._levelIcon.y = _bloodStripBg.y - 5;
            addChild(this._levelIcon);
         }
         if(this.player.playerInfo.ConsortiaName || this.player.playerInfo.honor)
         {
            this._consortiaName = ComponentFactory.Instance.creatComponentByStylename("GameLiving.ConsortiaName");
            this._consortiaName.text = this.player.playerInfo.showDesignation;
            if(this.player.playerInfo.ConsortiaID != 0)
            {
               _local_1 = GameManager.Instance.Current;
               _local_2 = PlayerManager.Instance.Self;
               if(_local_2.ConsortiaID == 0 || _local_2.ConsortiaID == this.player.playerInfo.ConsortiaID && _local_2.ZoneID == this.player.playerInfo.ZoneID || _local_1 && _local_1.gameMode == 2)
               {
                  this._consortiaName.setFrame(3);
               }
               else
               {
                  this._consortiaName.setFrame(2);
               }
            }
            else
            {
               this._consortiaName.setFrame(1);
            }
            this._consortiaName.x = _nickName.x;
            this._consortiaName.y = _nickName.y + _nickName.height / 2 + 5;
            addChild(this._consortiaName);
         }
         this._expView = new ExpMovie();
         addChild(this._expView);
         this._expView.y = -60;
         this._expView.x = -50;
         this._expView.scaleX = this._expView.scaleY = 1.5;
         this._facecontainer = new FaceContainer();
         addChild(this._facecontainer);
         this._facecontainer.y = -100;
         this._facecontainer.setNickName(_nickName.text);
         if(this._body.wing && !_info.playerInfo.wingHide)
         {
            this.addWing();
         }
         else
         {
            this.removeWing();
         }
         _propArray = new Array();
         this.__dirChanged(null);
         if(PlayerManager.Instance.Self.IsShowNewTitle == true)
         {
            if(this.player.playerInfo.honor != "" && (StateManager.currentStateType == "fighting" || StateManager.currentStateType == "dungeonRoom"))
            {
               _loc33_ = NewTitleManager.instance.getTitleByName(this.player.playerInfo.honor);
               if(_loc33_ && _loc33_.Show != "0" && _loc33_.Pic != "0")
               {
                  _loc22_ = LoaderManager.Instance.creatLoader(PathManager.solvePath("image/title/" + _loc33_.Pic + "/icon.png"),0);
                  _loc22_.addEventListener("complete",this.__onComplete);
                  LoaderManager.Instance.startLoad(_loc22_,true);
               }
            }
         }
      }
      
      protected function __onComplete(evt:LoaderEvent) : void
      {
         var _loc3_:BaseLoader = evt.loader;
         _loc3_.removeEventListener("complete",this.__onComplete);
         var _loc2_:Bitmap = _loc3_.content;
         if(_loc2_ && this.isLiving)
         {
            this._newTitle = _loc2_;
            this._newTitle.x = -_loc2_.width / 2;
            this._newTitle.y = this._player.y - this._player.height - this._newTitle.height + 20;
            addChild(this._newTitle);
            this._facecontainer && addChild(this._facecontainer);
         }
      }
      
      override protected function initListener() : void
      {
         super.initListener();
         this.player.addEventListener(LivingEvent.ADD_STATE,this.__addState);
         this.player.addEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
         this.player.addEventListener(LivingEvent.USING_ITEM,this.__usingItem);
         this.player.addEventListener(LivingEvent.USING_SPECIAL_SKILL,this.__usingSpecialKill);
         this.player.addEventListener(LivingEvent.DANDER_CHANGED,this.__danderChanged);
         this.player.addEventListener(LivingEvent.PLAYER_MOVETO,this.__playerMoveTo);
         this.player.addEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
         this.player.addEventListener(LivingEvent.PET_BEAT,this.__petBeat);
         ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         _info.addEventListener(LivingEvent.BOX_PICK,this.__boxPickHandler);
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         this.player.removeEventListener(LivingEvent.ADD_STATE,this.__addState);
         this.player.removeEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
         this.player.removeEventListener(LivingEvent.USING_ITEM,this.__usingItem);
         this.player.removeEventListener(LivingEvent.USING_SPECIAL_SKILL,this.__usingSpecialKill);
         this.player.removeEventListener(LivingEvent.DANDER_CHANGED,this.__danderChanged);
         this.player.removeEventListener(LivingEvent.PLAYER_MOVETO,this.__playerMoveTo);
         this.player.removeEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
         this.player.removeEventListener(LivingEvent.PET_BEAT,this.__petBeat);
         if(this._weaponMovie)
         {
            this._weaponMovie.addEventListener(Event.ENTER_FRAME,this.checkCurrentMovie);
         }
         ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         _info.removeEventListener(LivingEvent.BOX_PICK,this.__boxPickHandler);
      }
      
      protected function __usePetSkill(_arg_1:LivingEvent) : void
      {
         var _local_2:PetSkillTemplateInfo = PetSkillManager.getSkillByID(_arg_1.value);
         if(_local_2 == null)
         {
            throw new Error("找不到技能，技能ID为：" + _arg_1.value);
         }
         if(_local_2.isActiveSkill)
         {
            switch(_local_2.BallType)
            {
               case PetSkillTemplateInfo.BALL_TYPE_0:
                  this.usePetSkill(_local_2);
                  break;
               case PetSkillTemplateInfo.BALL_TYPE_1:
                  if(GameManager.Instance.Current.selfGamePlayer.team == info.team)
                  {
                     GameManager.Instance.Current.selfGamePlayer.soulPropEnabled = false;
                  }
                  break;
               case PetSkillTemplateInfo.BALL_TYPE_2:
                  if(GameManager.Instance.Current.selfGamePlayer.team == info.team)
                  {
                     GameManager.Instance.Current.selfGamePlayer.soulPropEnabled = false;
                  }
                  this.usePetSkill(_local_2,this.skipSelfTurn);
                  break;
               case PetSkillTemplateInfo.BALL_TYPE_3:
                  this.usePetSkill(_local_2);
            }
            this.UsedPetSkill.add(_local_2.ID,_local_2);
            SoundManager.instance.play("039");
         }
      }
      
      private function initBuff() : void
      {
         var _local_1:int = 0;
         var _local_2:FightBuffInfo = null;
         if(_info)
         {
            _info.turnBuffs = _info.outTurnBuffs;
            _buffBar.update(_info.turnBuffs);
            if(_info.turnBuffs.length > 0)
            {
               _buffBar.x = 5 - _buffBar.width / 2;
               _buffBar.y = bodyHeight * -1 - 23;
               addChild(_buffBar);
            }
            else if(_buffBar.parent)
            {
               _buffBar.parent.removeChild(_buffBar);
            }
            _local_1 = 0;
            while(_local_1 < _info.turnBuffs.length)
            {
               _local_2 = _info.turnBuffs[_local_1];
               _local_2.execute(this.info);
               _local_1++;
            }
         }
      }
      
      private function skipSelfTurn() : void
      {
         this.hidePetMovie();
         if(info is LocalPlayer)
         {
            act(new SelfSkipAction(LocalPlayer(info)));
         }
      }
      
      public function usePetSkill(_arg_1:PetSkillTemplateInfo, _arg_2:Function = null) : void
      {
         this._currentPetSkill = _arg_1;
         this.playPetMovie(_arg_1.Action,_info.pos,_arg_2);
      }
      
      private function __petBeat(_arg_1:LivingEvent) : void
      {
         var _local_2:String = _arg_1.paras[0];
         var _local_3:Point = _arg_1.paras[1];
         var _local_4:Array = _arg_1.paras[2];
         this.playPetMovie(_local_2,_local_3,this.updateHp,[_local_4]);
      }
      
      private function updateHp(_arg_1:Array) : void
      {
         var _local_2:Object = null;
         var _local_3:Living = null;
         var _local_4:int = 0;
         var _local_5:int = 0;
         var _local_6:int = 0;
         for each(_local_2 in _arg_1)
         {
            _local_3 = _local_2.target;
            _local_4 = _local_2.hp;
            _local_5 = _local_2.damage;
            _local_6 = _local_2.dander;
            _local_3.updateBlood(_local_4,3,_local_5);
            if(_local_3 is Player)
            {
               Player(_local_3).dander = _local_6;
            }
         }
         if(this._petMovie)
         {
            this._petMovie.hide();
         }
      }
      
      private function playPetMovie(_arg_1:String, _arg_2:Point, _arg_3:Function = null, _arg_4:Array = null) : void
      {
         if(!this._petMovie)
         {
            return;
         }
         this._petMovie.show(_arg_2.x,_arg_2.y);
         this._petMovie.direction = info.direction;
         if(_arg_3 == null)
         {
            this._petMovie.doAction(_arg_1,this.hidePetMovie);
         }
         else
         {
            this._petMovie.doAction(_arg_1,_arg_3,_arg_4);
         }
      }
      
      public function hidePetMovie() : void
      {
         if(this._petMovie)
         {
            this._petMovie.hide();
         }
      }
      
      override public function get movie() : Sprite
      {
         return this._player;
      }
      
      protected function __boxPickHandler(_arg_1:LivingEvent) : void
      {
         if(PlayerManager.Instance.Self.FightBag.itemNumber > 3)
         {
            ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.game.gameplayer.proplist.full"));
         }
      }
      
      override protected function __applySkill(_arg_1:LivingEvent) : void
      {
         var _local_2:Array = _arg_1.paras;
         var _local_3:int = _local_2[0];
         switch(_local_3)
         {
            case SkillType.ResolveHurt:
               this.applyResolveHurt(_local_2[1]);
               return;
            case SkillType.Revert:
               this.applyRevert(_local_2[1]);
               return;
            default:
               return;
         }
      }
      
      private function applyRevert(_arg_1:PackageIn) : void
      {
         map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y - 150,1,false,AnimationLevel.HIGHT));
         map.act(new RevertAction(map.spellKill(this),this.player,_arg_1));
      }
      
      private function applyResolveHurt(_arg_1:PackageIn) : void
      {
         map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y - 150,1,false,AnimationLevel.HIGHT));
         map.act(new ResolveHurtAction(map.spellKill(this),this.player,_arg_1));
      }
      
      protected function __addState(_arg_1:LivingEvent) : void
      {
      }
      
      protected function __usingItem(_arg_1:LivingEvent) : void
      {
         var _local_2:ItemTemplateInfo = null;
         if(_arg_1.paras[0] is ItemTemplateInfo)
         {
            _local_2 = _arg_1.paras[0];
            _propArray.push(_local_2.Pic);
            this.doUseItemAnimation(EquipType.hasPropAnimation(_arg_1.paras[0]) != null);
         }
         else if(_arg_1.paras[0] is DisplayObject)
         {
            _propArray.push(_arg_1.paras[0]);
            this.doUseItemAnimation();
         }
      }
      
      protected function __usingSpecialKill(_arg_1:LivingEvent) : void
      {
         _propArray.push("-1");
         this.doUseItemAnimation();
      }
      
      override protected function doUseItemAnimation(_arg_1:Boolean = false) : void
      {
         var _local_2:MovieClipWrapper = null;
         _local_2 = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.ghostPcikPropAsset")),true,true);
         _local_2.addFrameScriptAt(12,headPropEffect);
         SoundManager.instance.play("039");
         _local_2.movie.x = 0;
         _local_2.movie.y = -10;
         if(!_arg_1)
         {
            addChild(_local_2.movie);
         }
         if(_isLiving)
         {
            this.doAction(this._body.handClipAction);
            this.body.WingState = GameCharacter.GAME_WING_CLIP;
         }
      }
      
      protected function __danderChanged(_arg_1:LivingEvent) : void
      {
         if(this.player.dander >= Player.TOTAL_DANDER && _isLiving)
         {
            if(this._danderFire == null)
            {
               this._danderFire = MovieClip(ClassUtils.CreatInstance("asset.game.danderAsset"));
               this._danderFire.x = 3;
               this._danderFire.y = this._body.y + 5;
               this._danderFire.mouseEnabled = false;
               this._danderFire.mouseChildren = false;
            }
            this._danderFire.play();
            this._player.addChild(this._danderFire);
         }
         else if(this._danderFire && this._danderFire.parent)
         {
            this._danderFire.stop();
            this._player.removeChild(this._danderFire);
         }
      }
      
      override protected function __posChanged(_arg_1:LivingEvent) : void
      {
         pos = this.player.pos;
         if(_isLiving)
         {
            this._player.rotation = calcObjectAngle();
            this.player.playerAngle = this._player.rotation;
         }
         this.playerMove();
         if(map && map.smallMap)
         {
            map.smallMap.updatePos(smallView,pos);
         }
      }
      
      public function playerMove() : void
      {
      }
      
      override protected function __dirChanged(_arg_1:LivingEvent) : void
      {
         super.__dirChanged(_arg_1);
         if(this._facecontainer)
         {
            this._facecontainer.scaleX = 1;
         }
         if(!this.player.isLiving)
         {
            this.setSoulPos();
         }
      }
      
      override protected function __attackingChanged(_arg_1:LivingEvent) : void
      {
         super.__attackingChanged(_arg_1);
         this.attackingViewChanged();
      }
      
      protected function attackingViewChanged() : void
      {
         if(this.player.isAttacking && this.player.isLiving)
         {
            this._attackPlayerCite.gotoAndStop(_info.team);
            addChild(this._attackPlayerCite);
         }
         else if(contains(this._attackPlayerCite))
         {
            removeChild(this._attackPlayerCite);
         }
      }
      
      override protected function __hiddenChanged(_arg_1:LivingEvent) : void
      {
         super.__hiddenChanged(_arg_1);
         if(_info.isHidden && _info.team != GameManager.Instance.Current.selfGamePlayer.team)
         {
            _nickName.visible = false;
            if(_chatballview)
            {
               _chatballview.visible = false;
            }
         }
         else
         {
            _nickName.visible = true;
         }
      }
      
      override protected function __say(_arg_1:LivingEvent) : void
      {
         var _local_2:String = null;
         var _local_3:int = 0;
         if(!_info.isHidden)
         {
            _local_2 = _arg_1.paras[0];
            _local_3 = 0;
            if(_arg_1.paras[1])
            {
               _local_3 = _arg_1.paras[1];
            }
            if(_local_3 != 9)
            {
               _local_3 = this.player.playerInfo.paopaoType;
            }
            this.say(_local_2,_local_3);
         }
      }
      
      override protected function __bloodChanged(_arg_1:LivingEvent) : void
      {
         super.__bloodChanged(_arg_1);
         if(_arg_1.paras[0] != 0)
         {
            if(_isLiving)
            {
               this._body.doAction(this.getAction("cry"));
               this._body.WingState = GameCharacter.GAME_WING_CRY;
            }
         }
         updateBloodStrip();
      }
      
      override protected function __shoot(_arg_1:LivingEvent) : void
      {
         var _local_2:Array = _arg_1.paras[0];
         this.player.currentBomb = _local_2[0].Template.ID;
         if(RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM && !(this is GameLocalPlayer))
         {
            act(new PrepareShootAction(this));
            act(new ShootBombAction(this,_local_2,_arg_1.paras[1],_info.shootInterval));
         }
         else
         {
            map.act(new PrepareShootAction(this));
            map.act(new ShootBombAction(this,_local_2,_arg_1.paras[1],_info.shootInterval));
         }
      }
      
      protected function shootIntervalDegression() : void
      {
         if(_info.shootInterval == 12)
         {
            _info.shootInterval = 9;
            return;
         }
         if(_info.shootInterval == 9)
         {
            _info.shootInterval = 5;
            return;
         }
      }
      
      override protected function __beat(_arg_1:LivingEvent) : void
      {
         act(new PlayerBeatAction(this));
      }
      
      protected function __playerMoveTo(_arg_1:LivingEvent) : void
      {
         var _local_2:int = _arg_1.paras[0];
         switch(_local_2)
         {
            case 0:
               act(new PlayerWalkAction(this,_arg_1.paras[1],_arg_1.paras[2],this.getAction("walk")));
               return;
            case 1:
               act(new PlayerFallingAction(this,_arg_1.paras[1],_arg_1.paras[3],false));
               return;
            case 2:
               act(new GhostMoveAction(this,_arg_1.paras[1],_arg_1.paras[4]));
               return;
            case 3:
               act(new PlayerFallingAction(this,_arg_1.paras[1],_arg_1.paras[3],true));
               return;
            case 4:
               act(new PlayerWalkAction(this,_arg_1.paras[1],_arg_1.paras[2],this.getAction("stand")));
               return;
            default:
               return;
         }
      }
      
      override protected function __fall(_arg_1:LivingEvent) : void
      {
         act(new PlayerFallingAction(this,_arg_1.paras[0],true,false));
      }
      
      override protected function __moveTo(_arg_1:LivingEvent) : void
      {
      }
      
      override protected function __jump(_arg_1:LivingEvent) : void
      {
      }
      
      private function setSoulPos() : void
      {
         if(this._player.scaleX == -1)
         {
            this._body.x = -6;
         }
         else
         {
            this._body.x = -13;
         }
      }
      
      public function get character() : ShowCharacter
      {
         return this._character;
      }
      
      public function get body() : GameCharacter
      {
         return this._body;
      }
      
      public function get player() : Player
      {
         return info as Player;
      }
      
      private function addWing() : void
      {
         if(this._body.wing == null)
         {
            return;
         }
         this._body.setWingPos(this._body.weaponX * this._body.scaleX,this._body.weaponY * this._body.scaleY);
         this._body.setWingScale(this._body.scaleX,this._body.scaleY);
         if(this._body.leftWing && this._body.leftWing.parent != this._player)
         {
            this._player.addChild(this._body.rightWing);
            this._player.addChildAt(this._body.leftWing,0);
         }
         this._body.switchWingVisible(_info.isLiving);
         this._body.WingState = GameCharacter.GAME_WING_WAIT;
      }
      
      private function removeWing() : void
      {
         if(this._body.leftWing && this._body.leftWing.parent)
         {
            this._body.leftWing.parent.removeChild(this._body.leftWing);
         }
         if(this._body.rightWing && this._body.rightWing.parent)
         {
            this._body.rightWing.parent.removeChild(this._body.rightWing);
         }
      }
      
      public function get weaponMovie() : MovieClip
      {
         return this._weaponMovie;
      }
      
      public function set weaponMovie(_arg_1:MovieClip) : void
      {
         if(_arg_1 != this._weaponMovie)
         {
            if(this._weaponMovie && this._weaponMovie.parent)
            {
               this._weaponMovie.removeEventListener(Event.ENTER_FRAME,this.checkCurrentMovie);
               this._weaponMovie.parent.removeChild(this._weaponMovie);
            }
            this._weaponMovie = _arg_1;
            this._currentWeaponMovie = null;
            this._currentWeaponMovieAction = "";
            if(this._weaponMovie)
            {
               this._weaponMovie.stop();
               this._weaponMovie.addEventListener(Event.ENTER_FRAME,this.checkCurrentMovie);
               this._weaponMovie.x = this._body.weaponX * this._body.scaleX;
               this._weaponMovie.y = this._body.weaponY * this._body.scaleY;
               this._weaponMovie.scaleX = this._body.scaleX;
               this._weaponMovie.scaleY = this._body.scaleY;
               this._weaponMovie.visible = false;
               this._player.addChild(this._weaponMovie);
               if(this._body.wing && !_info.playerInfo.wingHide)
               {
                  this.addWing();
               }
               else
               {
                  this.removeWing();
               }
            }
         }
      }
      
      private function checkCurrentMovie(_arg_1:Event) : void
      {
         if(this._weaponMovie == null)
         {
            return;
         }
         this._currentWeaponMovie = this._weaponMovie.getChildAt(0) as MovieClip;
         if(this._currentWeaponMovie && this._currentWeaponMovieAction != "")
         {
            this._weaponMovie.removeEventListener(Event.ENTER_FRAME,this.checkCurrentMovie);
            this.setWeaponMoiveActionSyc(this._currentWeaponMovieAction);
         }
      }
      
      public function setWeaponMoiveActionSyc(_arg_1:String) : void
      {
         if(this._currentWeaponMovie)
         {
            this._currentWeaponMovie.gotoAndPlay(_arg_1);
         }
         else
         {
            this._currentWeaponMovieAction = _arg_1;
         }
      }
      
      override public function die() : void
      {
         super.die();
         this.player.isSpecialSkill = false;
         this.player.skill = -1;
         SoundManager.instance.play("042");
         this.weaponMovie = null;
         this._player.rotation = 0;
         this._player.y = 25;
         if(contains(this._attackPlayerCite))
         {
            removeChild(this._attackPlayerCite);
         }
         if(this._newTitle)
         {
            if(contains(this._newTitle))
            {
               removeChild(this._newTitle);
            }
         }
         _HPStrip.visible = false;
         _bloodStripBg.visible = false;
         var _local_1:TombView = new TombView();
         _local_1.pos = this.pos;
         _map.addPhysical(_local_1);
         _local_1.startMoving();
         this._tomb = new TombView();
         this._tomb.pos = this.pos;
         if(_map)
         {
            _map.addPhysical(this._tomb);
         }
         this._tomb.startMoving();
         this.player.pos = new Point(x,y - 70);
         this.player.startMoving();
         if(RoomManager.Instance.current && RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            this._tomb.addEventListener(GameEvent.UPDATE_NAMEPOS,this.__updateNamePos);
            this._player.visible = false;
         }
         else
         {
            this.doAction(GameCharacter.SOUL);
         }
         this.setSoulPos();
         _nickName.y += 10;
         if(this._consortiaName)
         {
            this._consortiaName.y += 10;
         }
         if(this._levelIcon)
         {
            this._levelIcon.y += 20;
         }
         if(this._leagueRank)
         {
            this._leagueRank.y += 20;
         }
         _map.setTopPhysical(this);
         if(this._danderFire && this._danderFire.parent)
         {
            this._danderFire.parent.removeChild(this._danderFire);
         }
         this._danderFire = null;
      }
      
      protected function __updateNamePos(_arg_1:Event) : void
      {
         this.y = this._tomb.y - 30;
      }
      
      override protected function __beginNewTurn(_arg_1:LivingEvent) : void
      {
         super.__beginNewTurn(_arg_1);
         if(_isLiving)
         {
            this._body.doAction(this._body.standAction);
            this._body.randomCryType();
         }
         this.weaponMovie = null;
         this.player.skill = -1;
         this.isShootPrepared = false;
         _info.shootInterval = Player.SHOOT_INTERVAL;
         if(contains(this._attackPlayerCite))
         {
            removeChild(this._attackPlayerCite);
         }
      }
      
      private function __getChat(_arg_1:ChatEvent) : void
      {
         if(this.player.isHidden && this.player.team != GameManager.Instance.Current.selfGamePlayer.team)
         {
            return;
         }
         var _local_2:ChatData = ChatData(_arg_1.data).clone();
         _local_2.msg = Helpers.deCodeString(_local_2.msg);
         if(_local_2.channel == 2 || _local_2.channel == 3)
         {
            return;
         }
         if(_local_2.zoneID == -1)
         {
            if(_local_2.senderID == this.player.playerInfo.ID)
            {
               this.say(_local_2.msg,this.player.playerInfo.paopaoType);
            }
         }
         else if(_local_2.senderID == this.player.playerInfo.ID && _local_2.zoneID == this.player.playerInfo.ZoneID)
         {
            this.say(_local_2.msg,this.player.playerInfo.paopaoType);
         }
      }
      
      private function say(_arg_1:String, _arg_2:int) : void
      {
         _chatballview.setText(_arg_1,_arg_2);
         addChild(_chatballview);
         fitChatBallPos();
      }
      
      override protected function get popPos() : Point
      {
         if(!_info.isLiving)
         {
            return new Point(18,-20);
         }
         return new Point(18,-40);
      }
      
      override protected function get popDir() : Point
      {
         return null;
      }
      
      private function __getFace(_arg_1:ChatEvent) : void
      {
         var _local_3:int = 0;
         var _local_4:int = 0;
         if(this.player.isHidden && this.player.team != GameManager.Instance.Current.selfGamePlayer.team)
         {
            return;
         }
         var _local_2:Object = _arg_1.data;
         if(_local_2["playerid"] == this.player.playerInfo.ID)
         {
            _local_3 = _local_2["faceid"];
            _local_4 = _local_2["delay"];
            if(_local_3 >= 49)
            {
               setTimeout(this.showFace,_local_4,_local_3);
            }
            else
            {
               this.showFace(_local_3);
            }
            if(_local_3 < 49 && _local_3 > 0)
            {
               ChatManager.Instance.dispatchEvent(new ChatEvent(ChatEvent.SET_FACECONTIANER_LOCTION));
            }
         }
      }
      
      private function showFace(_arg_1:int) : void
      {
         if(this._facecontainer == null)
         {
            return;
         }
         this._facecontainer.scaleX = 1;
         this._facecontainer.setFace(_arg_1);
      }
      
      public function shootPoint() : Point
      {
         var _local_1:Point = this._ballpos;
         _local_1 = this._body.localToGlobal(_local_1);
         return _map.globalToLocal(_local_1);
      }
      
      override public function doAction(_arg_1:*) : void
      {
         if(_arg_1 is PlayerAction)
         {
            this._body.doAction(_arg_1);
         }
      }
      
      override public function dispose() : void
      {
         this.removeListener();
         super.dispose();
         if(_chatballview)
         {
            _chatballview.dispose();
            _chatballview = null;
         }
         if(this._facecontainer)
         {
            this._facecontainer.dispose();
            this._facecontainer = null;
         }
         if(this._consortiaName)
         {
            ObjectUtils.disposeObject(this._consortiaName);
         }
         this._consortiaName = null;
         if(this._attackPlayerCite)
         {
            if(this._attackPlayerCite.parent)
            {
               this._attackPlayerCite.parent.removeChild(this._attackPlayerCite);
            }
         }
         this._attackPlayerCite = null;
         this._character = null;
         this._body = null;
         if(this._weaponMovie)
         {
            this._weaponMovie.stop();
            this._weaponMovie = null;
         }
         ObjectUtils.disposeObject(this._tomb);
         this._tomb = null;
         if(this._danderFire && this._danderFire.parent)
         {
            this._danderFire.stop();
            this._player.removeChild(this._danderFire);
         }
         if(this._levelIcon)
         {
            if(this._levelIcon.parent)
            {
               this._levelIcon.parent.removeChild(this._levelIcon);
            }
            this._levelIcon.dispose();
         }
         this._levelIcon = null;
         if(this._leagueRank)
         {
            ObjectUtils.disposeObject(this._leagueRank);
         }
         this._leagueRank = null;
         ObjectUtils.disposeObject(this._expView);
         this._expView = null;
         ObjectUtils.disposeObject(this._newTitle);
         this._newTitle = null;
      }
      
      override protected function __bombed(_arg_1:LivingEvent) : void
      {
         this.body.bombed();
      }
      
      override public function setMap(_arg_1:Map) : void
      {
         super.setMap(_arg_1);
         if(_arg_1)
         {
            this.__posChanged(null);
         }
      }
      
      override public function setProperty(_arg_1:String, _arg_2:String) : void
      {
         var _local_3:StringObject = null;
         var _local_4:Number = NaN;
         _local_3 = new StringObject(_arg_2);
         switch(_arg_1)
         {
            case "GhostGPUp":
               _local_4 = _local_3.getInt();
               this._expView.exp = _local_4;
               this._expView.play();
               this._body.doAction(GameCharacter.SOUL_SMILE);
         }
         super.setProperty(_arg_1,_arg_2);
      }
      
      public function set gainEXP(_arg_1:int) : void
      {
         _nickName.text = String(_arg_1);
      }
      
      override public function setActionMapping(_arg_1:String, _arg_2:String) : void
      {
         if(_arg_1.length <= 0)
         {
            return;
         }
         this.labelMapping[_arg_1] = _arg_2;
      }
      
      public function getAction(_arg_1:String) : PlayerAction
      {
         if(this.labelMapping[_arg_1])
         {
            _arg_1 = this.labelMapping[_arg_1];
         }
         switch(_arg_1)
         {
            case "stand":
               return this._body.standAction;
            case "walk":
               return this._body.walkAction;
            case "cry":
               return GameCharacter.CRY;
            case "soul":
               return GameCharacter.SOUL;
            default:
               return this._body.standAction;
         }
      }
   }
}
