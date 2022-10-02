package ddt.view.character
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class RoomCharacter extends BaseCharacter
   {
      
      public static const STANDBY:String = "standBy";
      
      public static const CLOSE_EYES:String = "close_Eyes";
      
      public static const WANDERING:String = "wandering";
      
      public static const DAZED:String = "dazed";
      
      public static const SMILE:String = "smile";
      
      public static const SELF_SATISFIED:String = "selfSatisfied";
      
      public static const RUT:String = "rut";
      
      public static const WHISTLE:String = "whistle";
      
      public static const MUG:String = "mug";
      
      private static const RANDOM_EXPRESSION:Array = [CLOSE_EYES,WANDERING,DAZED,SMILE,WHISTLE];
      
      public static const HAPPY:String = "happy";
      
      public static const LUAGH:String = "luagh";
      
      public static const NAUGHTY:String = "naughty";
      
      public static const SAD:String = "sad";
      
      public static const SARROWFUL:String = "sarrowful";
      
      public static const LOOK_AWRY:String = "look_awry";
      
      public static const ANGRY:String = "angry";
      
      public static const SULK:String = "sulk";
      
      public static const COLD:String = "cold";
      
      public static const DIZZY:String = "dizzy";
      
      public static const SUPRISE:String = "suprise";
      
      public static const SICK:String = "sick";
      
      public static const SLEEPING:String = "sleeping";
      
      public static const OH_MY_GOD:String = "oh_My_God";
      
      public static const LOVE:String = "love";
      
      private static var _keyWords:Dictionary;
       
      
      private var _faceUpBmd:BitmapData;
      
      private var _faceBmd:BitmapData;
      
      private var _suitBmd:BitmapData;
      
      private var _light1:MovieClip;
      
      private var _light2:MovieClip;
      
      private var _light01:BaseLightLayer;
      
      private var _light02:SinpleLightLayer;
      
      private var _wing:MovieClip;
      
      private var _currentAction:RoomPlayerAction;
      
      private var _showGun:Boolean;
      
      private var _recordNimbus:int;
      
      private var _playAnimation:Boolean = true;
      
      private var _faceFrames:Array;
      
      private var _rect:Rectangle;
      
      private var _faceRect:Rectangle;
      
      private var _test:int = 0;
      
      public function RoomCharacter(param1:PlayerInfo, param2:Boolean = false)
      {
         this._faceRect = new Rectangle(40,0,250,232);
         this._currentAction = RoomPlayerAction.creatAction(STANDBY,param1.getShowSuits());
         this._showGun = param2;
         super(param1,true);
      }
      
      public static function getActionByWord(param1:String) : String
      {
         var _loc2_:* = null;
         for(_loc2_ in KEY_WORDS)
         {
            if(_keyWords[_loc2_].indexOf(param1) > -1)
            {
               return _loc2_;
            }
         }
         return STANDBY;
      }
      
      private static function get KEY_WORDS() : Dictionary
      {
         if(_keyWords == null)
         {
            _keyWords = new Dictionary();
            _keyWords[HAPPY] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.HAPPY").split("|");
            _keyWords[LUAGH] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.LUAGH").split("|");
            _keyWords[NAUGHTY] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.NAUGHTY").split("|");
            _keyWords[SAD] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.SAD").split("|");
            _keyWords[SARROWFUL] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.SARROWFUL").split("|");
            _keyWords[LOOK_AWRY] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.LOOK_AWRY").split("|");
            _keyWords[ANGRY] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.ANGRY").split("|");
            _keyWords[SULK] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.SULK").split("|");
            _keyWords[COLD] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.COLD").split("|");
            _keyWords[DIZZY] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.DIZZY").split("|");
            _keyWords[SUPRISE] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.SUPRISE").split("|");
            _keyWords[SICK] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.SICK").split("|");
            _keyWords[SLEEPING] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.SLEEPING").split("|");
            _keyWords[OH_MY_GOD] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.OH_MY_GOD").split("|");
            _keyWords[LOVE] = LanguageMgr.GetTranslation("room.roomPlayerActionKey.LOVE").split("|");
         }
         return _keyWords;
      }
      
      override public function set showGun(param1:Boolean) : void
      {
         this._showGun = param1;
      }
      
      override protected function initLoader() : void
      {
         _loader = _factory.createLoader(_info,CharacterLoaderFactory.ROOM);
         RoomCharaterLoader(_loader).showWeapon = this._showGun;
      }
      
      override protected function setContent() : void
      {
         var _loc1_:Array = null;
         if(_loader != null)
         {
            if(this._suitBmd && this._suitBmd != _loader.getContent()[0])
            {
               this._suitBmd.dispose();
            }
            this._suitBmd = _loader.getContent()[0];
            if(this._faceBmd && this._faceBmd != _loader.getContent()[2])
            {
               this._faceBmd.dispose();
            }
            this._faceBmd = _loader.getContent()[2];
            if(this._faceUpBmd && this._faceUpBmd != _loader.getContent()[1])
            {
               this._faceUpBmd.dispose();
            }
            this._faceUpBmd = _loader.getContent()[1];
            if(this._wing && this._wing.parent)
            {
               this._wing.parent.removeChild(this._wing);
            }
            this._wing = _loader.getContent()[3];
            if(this._wing && !this._playAnimation)
            {
               this.stopMovieClip(this._wing);
            }
         }
         _body.width = BASE_WIDTH;
         _body.height = BASE_HEIGHT;
         _body.cacheAsBitmap = true;
         if(_info.getSuitsType() == 1)
         {
            _body.y = -13;
            _loc1_ = _info.Style.split(",");
            if(ItemManager.Instance.getTemplateById(int(_loc1_[8].split("|")[0])).Property1 != "1")
            {
               if(this._wing)
               {
                  this._wing.y = -40;
               }
            }
         }
         else
         {
            _body.y = 0;
            if(this._wing)
            {
               this._wing.y = 0;
            }
         }
         this.sortIndex();
      }
      
      private function sortIndex() : void
      {
         if(this._light1 != null)
         {
            _container.addChild(this._light1);
         }
         if(this._wing != null && !_info.wingHide)
         {
            _container.addChild(this._wing);
         }
         if(_body != null)
         {
            _container.addChild(_body);
         }
         if(this._light2 != null)
         {
            _container.addChild(this._light2);
         }
      }
      
      override protected function initSizeAndPics() : void
      {
         setCharacterSize(ShowCharacter.BIG_WIDTH,ShowCharacter.BIG_HEIGHT);
         setPicNum(1,4);
         this._rect = new Rectangle(0,0,_characterWidth,_characterHeight);
      }
      
      override public function update() : void
      {
         if(!this._currentAction.repeat && this._currentAction.isEnd)
         {
            this.randomAction();
         }
         this.drawFrame(this._currentAction.next());
      }
      
      private function randomAction() : void
      {
         var _loc1_:Number = Math.random();
         if(_loc1_ < 0.5)
         {
            this._currentAction = RoomPlayerAction.creatAction(CLOSE_EYES,_info.getShowSuits());
         }
         else
         {
            this._currentAction = RoomPlayerAction.creatAction(WANDERING,_info.getShowSuits());
         }
      }
      
      override protected function __loadComplete(param1:ICharacterLoader) : void
      {
         super.__loadComplete(param1);
         this.updateLight();
      }
      
      private function updateLight() : void
      {
         if(_info == null)
         {
            return;
         }
         if(this._recordNimbus != _info.Nimbus)
         {
            this._recordNimbus = _info.Nimbus;
            if(_info.getHaveLight())
            {
               if(this._light02)
               {
                  this._light02.dispose();
               }
               this._light02 = new SinpleLightLayer(_info.Nimbus);
               this._light02.load(this.callBack02);
            }
            else
            {
               if(this._light02)
               {
                  this._light02.dispose();
               }
               if(this._light2 && this._light2.parent)
               {
                  this._light2.parent.removeChild(this._light2);
               }
               this._light2 = null;
            }
            if(_info.getHaveCircle())
            {
               if(this._light01)
               {
                  this._light01.dispose();
               }
               if(this._light1 && this._light1.parent)
               {
                  this._light1.parent.removeChild(this._light1);
               }
               this._light1 = null;
               this._light01 = new BaseLightLayer(_info.Nimbus);
               this._light01.load(this.callBack01);
            }
            else
            {
               if(this._light01)
               {
                  this._light01.dispose();
               }
               if(this._light1 && this._light1.parent)
               {
                  this._light1.parent.removeChild(this._light1);
               }
               this._light1 = null;
            }
         }
      }
      
      private function callBack01(param1:BaseLightLayer) : void
      {
         if(this._light1 && this._light1.parent)
         {
            this._light1.parent.removeChild(this._light1);
         }
         this._light1 = param1.getContent() as MovieClip;
         if(this._light1 != null)
         {
            _container.addChildAt(this._light1,0);
            this._light1.x = 47;
            this._light1.y = 65;
         }
         this.restoreAnimationState();
         this.sortIndex();
      }
      
      private function callBack02(param1:SinpleLightLayer) : void
      {
         if(this._light2 && this._light2.parent)
         {
            this._light2.parent.removeChild(this._light2);
         }
         this._light2 = param1.getContent() as MovieClip;
         if(this._light2 != null)
         {
            _container.addChild(this._light2);
            this._light2.x = 45;
            this._light2.y = 126;
         }
         this.restoreAnimationState();
         this.sortIndex();
      }
      
      public function stopAnimation() : void
      {
         this._playAnimation = false;
         this.stopAllMoiveClip();
      }
      
      public function playAnimation() : void
      {
         this._playAnimation = true;
         this.playAllMoiveClip();
      }
      
      private function stopAllMoiveClip() : void
      {
         this.stopMovieClip(this._light1);
         this.stopMovieClip(this._light2);
         this.stopMovieClip(this._wing);
      }
      
      private function playAllMoiveClip() : void
      {
         this.playMovieClip(this._light1);
         this.playMovieClip(this._light2);
         this.playMovieClip(this._wing);
      }
      
      private function restoreAnimationState() : void
      {
         if(this._playAnimation)
         {
            this.playAllMoiveClip();
         }
         else
         {
            this.stopAllMoiveClip();
         }
      }
      
      private function stopMovieClip(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         if(param1)
         {
            param1.gotoAndStop(1);
            if(param1.numChildren > 0)
            {
               _loc2_ = 0;
               while(_loc2_ < param1.numChildren)
               {
                  this.stopMovieClip(param1.getChildAt(_loc2_) as MovieClip);
                  _loc2_++;
               }
            }
         }
      }
      
      private function playMovieClip(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         if(param1)
         {
            param1.gotoAndPlay(1);
            if(param1.numChildren > 0)
            {
               _loc2_ = 0;
               while(_loc2_ < param1.numChildren)
               {
                  this.playMovieClip(param1.getChildAt(_loc2_) as MovieClip);
                  _loc2_++;
               }
            }
         }
      }
      
      override public function doAction(param1:*) : void
      {
         if(param1 == "")
         {
            return;
         }
         this._currentAction = RoomPlayerAction.creatAction(param1,_info.getShowSuits());
      }
      
      override protected function createFrames() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Rectangle = null;
         super.createFrames();
         this._faceFrames = [];
         var _loc1_:int = 0;
         while(_loc1_ < _picLines)
         {
            _loc2_ = 0;
            while(_loc2_ < _picsPerLine)
            {
               _loc3_ = new Rectangle(_loc2_ * 250,_loc1_ * 232,250,232);
               this._faceFrames.push(_loc3_);
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      override public function drawFrame(param1:int, param2:int = 0, param3:Boolean = true) : void
      {
         _body.bitmapData.fillRect(this._rect,0);
         if(_info.getShowSuits() && this._suitBmd)
         {
            _body.bitmapData.copyPixels(this._suitBmd,_frames[param1],new Point(0,0),null,null,true);
         }
         else if(this._faceBmd != null && this._faceUpBmd != null)
         {
            _body.bitmapData.copyPixels(this._faceBmd,_frames[param1],new Point(0,0),null,null,true);
            _body.bitmapData.copyPixels(this._faceUpBmd,_frames[0],new Point(0,0),null,null,true);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._faceUpBmd)
         {
            this._faceUpBmd.dispose();
         }
         this._faceUpBmd = null;
         if(this._faceBmd)
         {
            this._faceBmd.dispose();
         }
         this._faceBmd = null;
         if(this._suitBmd)
         {
            this._suitBmd.dispose();
         }
         this._suitBmd = null;
         if(this._light1)
         {
            ObjectUtils.disposeObject(this._light1);
         }
         this._light1 = null;
         if(this._light2)
         {
            ObjectUtils.disposeObject(this._light2);
         }
         this._light2 = null;
         if(this._light01)
         {
            ObjectUtils.disposeObject(this._light01);
         }
         this._light01 = null;
         if(this._light02)
         {
            ObjectUtils.disposeObject(this._light02);
         }
         this._light02 = null;
         if(this._wing)
         {
            ObjectUtils.disposeObject(this._wing);
         }
         this._wing = null;
         this._currentAction = null;
         _keyWords = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
