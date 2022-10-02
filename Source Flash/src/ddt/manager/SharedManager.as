package ddt.manager
{
   import ddt.data.FightPropMode;
   import ddt.events.SharedEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.SharedObject;
   import flash.utils.Dictionary;
   
   [Event(name="change",type="flash.events.Event")]
   public class SharedManager extends EventDispatcher
   {
      
      public static var RIGHT_PROP:Array = [10001,10003,10002,10004,10005,10006,10007];
      
      public static const KEY_SET_ABLE:Array = [10001,10003,10002,10004,10005,10006,10007,10008];
      
      private static var instance:SharedManager = new SharedManager();
       
      
      public var allowMusic:Boolean = true;
      
      public var allowSound:Boolean = true;
      
      public var showTopMessageBar:Boolean = true;
      
      private var _showInvateWindow:Boolean = true;
      
      public var showParticle:Boolean = true;
      
      public var showOL:Boolean = true;
      
      public var lastBuyCount:int;
      
      public var showCI:Boolean = true;
      
      public var showHat:Boolean = true;
      
      public var showGlass:Boolean = true;
      
      public var showSuit:Boolean = true;
      
      public var fastReplys:Object;
      
      public var musicVolumn:int = 50;
      
      public var soundVolumn:int = 50;
      
      public var StrengthMoney:int = 1000;
      
      public var ComposeMoney:int = 1000;
      
      public var FusionMoney:int = 1000;
      
      public var TransferMoney:int = 1000;
      
      public var KeyAutoSnap:Boolean = true;
      
      public var ShowBattleGuide:Boolean = true;
      
      public var isHintPropExpire:Boolean = true;
      
      public var AutoReady:Boolean = true;
      
      public var GameKeySets:Object;
      
      public var AuctionInfos:Object;
      
      public var AuctionIDs:Object;
      
      public var setBagLocked:Boolean = false;
      
      public var hasStrength3:Object;
      
      public var recentContactsID:Object;
      
      public var StoreBuyInfo:Object;
      
      public var deadtip:int = 0;
      
      public var hasCheckedOverFrameRate:Boolean = false;
      
      public var hasEnteredFightLib:Object;
      
      public var isAffirm:Boolean = true;
      
      public var recommendNum:int = 0;
      
      public var isRecommend:Boolean = false;
      
      public var isSetingMovieClip:Boolean = true;
      
      public var voteData:Dictionary;
      
      public var giftFirstShow:Boolean = true;
      
      public var cardSystemShow:Boolean = true;
      
      public var texpSystemShow:Boolean = true;
      
      public var divorceBoolean:Boolean = true;
      
      public var friendBrithdayName:String = "";
      
      private var _autoSnsSend:Boolean = false;
      
      public var spacialReadedMail:Dictionary;
      
      public var deleteMail:Dictionary;
      
      public var privateChatRecord:Dictionary;
      
      public var autoWish:Boolean = false;
      
      private var _allowSnsSend:Boolean = false;
      
      private var _autoCaddy:Boolean = false;
      
      private var _autoOfferPack:Boolean = false;
      
      private var _autoBead:Boolean = false;
      
      private var _autoWishBead:Boolean = false;
      
      private var _edictumVersion:String = "";
      
      private var _propLayerMode:int = 2;
      
      private var _isCommunity:Boolean = true;
      
      public var awayAutoReply:Object;
      
      public var busyAutoReply:Object;
      
      public var noDistrubAutoReply:Object;
      
      public var shoppingAutoReply:Object;
      
      public var isRefreshPet:Boolean = false;
      
      public var isRefreshSkill:Boolean = false;
      
      public var isRefreshBand:Boolean = false;
      
      private var _propTransparent:Boolean = false;
      
      public var boxType:int = 1;
      
      public var stoneFriend:Boolean = true;
      
      public var halliconExperienceStep:int = 0;
	  
	  public var isBuyInteger:Boolean = false;
	  
	  public var isBuyIntegerBind:Boolean = true;
	  
	  public var isBuyHit:Boolean = false;
	  
	  public var isBuyHitBind:Boolean = true;
      
      public function SharedManager()
      {
         this.fastReplys = new Object();
         this.GameKeySets = new Object();
         this.AuctionInfos = new Object();
         this.AuctionIDs = new Object();
         this.hasStrength3 = new Object();
         this.recentContactsID = new Object();
         this.StoreBuyInfo = new Object();
         this.hasEnteredFightLib = new Object();
         this.voteData = new Dictionary();
         this.spacialReadedMail = new Dictionary();
         this.deleteMail = new Dictionary();
         this.privateChatRecord = new Dictionary();
         this.awayAutoReply = new Object();
         this.busyAutoReply = new Object();
         this.noDistrubAutoReply = new Object();
         this.shoppingAutoReply = new Object();
         super();
      }
      
      public static function get Instance() : SharedManager
      {
         return instance;
      }
      
      public function get autoSnsSend() : Boolean
      {
         return this._autoSnsSend;
      }
      
      public function set autoSnsSend(param1:Boolean) : void
      {
         if(this._autoSnsSend == param1)
         {
            return;
         }
         this._autoSnsSend = param1;
         this.save();
      }
      
      public function get allowSnsSend() : Boolean
      {
         return this._allowSnsSend;
      }
      
      public function get autoCaddy() : Boolean
      {
         return this._autoCaddy;
      }
      
      public function set autoCaddy(param1:Boolean) : void
      {
         if(this._autoCaddy != param1)
         {
            this._autoCaddy = param1;
            this.save();
         }
      }
      
      public function get autoOfferPack() : Boolean
      {
         return this._autoOfferPack;
      }
      
      public function set autoOfferPack(param1:Boolean) : void
      {
         if(this._autoOfferPack != param1)
         {
            this._autoOfferPack = param1;
            this.save();
         }
      }
      
      public function get autoBead() : Boolean
      {
         return this._autoBead;
      }
      
      public function set autoWishBead(param1:Boolean) : void
      {
         if(this._autoWishBead != param1)
         {
            this._autoWishBead = param1;
            this.save();
         }
      }
      
      public function get autoWishBead() : Boolean
      {
         return this._autoWishBead;
      }
      
      public function set autoBead(param1:Boolean) : void
      {
         if(this._autoBead != param1)
         {
            this._autoBead = param1;
            this.save();
         }
      }
      
      public function get edictumVersion() : String
      {
         return this._edictumVersion;
      }
      
      public function set edictumVersion(param1:String) : void
      {
         if(this._edictumVersion != param1)
         {
            this._edictumVersion = param1;
            this.save();
         }
      }
      
      public function get propLayerMode() : int
      {
         if(PlayerManager.Instance.Self.Grade < 4)
         {
            return FightPropMode.VERTICAL;
         }
         return this._propLayerMode;
      }
      
      public function set propLayerMode(param1:int) : void
      {
         if(this._propLayerMode != param1)
         {
            this._propLayerMode = param1;
            this.save();
         }
      }
      
      public function set allowSnsSend(param1:Boolean) : void
      {
         if(this._allowSnsSend == param1)
         {
            return;
         }
         this._allowSnsSend = param1;
         this.save();
      }
      
      public function get showInvateWindow() : Boolean
      {
         return this._showInvateWindow;
      }
      
      public function set showInvateWindow(param1:Boolean) : void
      {
         this._showInvateWindow = param1;
      }
      
      public function get isCommunity() : Boolean
      {
         return this._isCommunity;
      }
      
      public function set isCommunity(param1:Boolean) : void
      {
         this._isCommunity = param1;
      }
      
      public function setup() : void
      {
         this.load();
      }
      
      public function reset() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal("road");
         _loc1_.clear();
         _loc1_.flush(20 * 1024 * 1024);
      }
      
      private function load() : void
      {
         var so:SharedObject = null;
         var key:String = null;
         var keyII:String = null;
         var keyIII:String = null;
         var keyIV:String = null;
         var keyV:String = null;
         var keyP:String = null;
         var i:int = 0;
         var j:int = 0;
         var k:String = null;
         var id:String = null;
         var key1:String = null;
         var key2:String = null;
         var key3:String = null;
         var key4:String = null;
         var key5:String = null;
         var key6:String = null;
         var key7:String = null;
         try
         {
            so = SharedObject.getLocal("road");
            this.AuctionInfos = new Object();
            if(so && so.data)
            {
               if(so.data["allowMusic"] != undefined)
               {
                  this.allowMusic = so.data["allowMusic"];
               }
               if(so.data["allowSound"] != undefined)
               {
                  this.allowSound = so.data["allowSound"];
               }
               if(so.data["showTopMessageBar"] != undefined)
               {
                  this.showTopMessageBar = so.data["showTopMessageBar"];
               }
               if(so.data["showInvateWindow"] != undefined)
               {
                  this.showInvateWindow = so.data["showInvateWindow"];
               }
               if(so.data["showParticle"] != undefined)
               {
                  this.showParticle = so.data["showParticle"];
               }
               if(so.data["showOL"] != undefined)
               {
                  this.showOL = so.data["showOL"];
               }
               if(so.data["showCI"] != undefined)
               {
                  this.showCI = so.data["showCI"];
               }
               if(so.data["showHat"] != undefined)
               {
                  this.showHat = so.data["showHat"];
               }
               if(so.data["showGlass"] != undefined)
               {
                  this.showGlass = so.data["showGlass"];
               }
               if(so.data["showSuit"] != undefined)
               {
                  this.showSuit = so.data["showSuit"];
               }
               if(so.data["musicVolumn"] != undefined)
               {
                  this.musicVolumn = so.data["musicVolumn"];
               }
               if(so.data["soundVolumn"] != undefined)
               {
                  this.soundVolumn = so.data["soundVolumn"];
               }
               if(so.data["KeyAutoSnap"] != undefined)
               {
                  this.KeyAutoSnap = so.data["KeyAutoSnap"];
               }
               if(so.data["giftFirstShow"] != undefined)
               {
                  this.giftFirstShow = so.data["giftFirstShow"];
               }
               if(so.data["cardSystemShow"] != undefined)
               {
                  this.cardSystemShow = so.data["cardSystemShow"];
               }
               if(so.data["texpSystemShow"] != undefined)
               {
                  this.texpSystemShow = so.data["texpSystemShow"];
               }
               if(so.data["divorceBoolean"] != undefined)
               {
                  this.divorceBoolean = so.data["divorceBoolean"];
               }
               if(so.data["friendBrithdayName"] != undefined)
               {
                  this.friendBrithdayName = so.data["friendBrithdayName"];
               }
               if(so.data["AutoReady"] != undefined)
               {
                  this.AutoReady = so.data["AutoReady"];
               }
               if(so.data["ShowBattleGuide"] != undefined)
               {
                  this.ShowBattleGuide = so.data["ShowBattleGuide"];
               }
               if(so.data["isHintPropExpire"] != undefined)
               {
                  this.isHintPropExpire = so.data["isHintPropExpire"];
               }
               if(so.data["hasCheckedOverFrameRate"] != undefined)
               {
                  this.hasCheckedOverFrameRate = so.data["hasCheckedOverFrameRate"];
               }
               if(so.data["isRecommend"] != undefined)
               {
                  this.isRecommend = so.data["isRecommend"];
               }
               if(so.data["recommendNum"] != undefined)
               {
                  this.recommendNum = so.data["recommendNum"];
               }
               if(so.data["isSetingMovieClip"] != undefined)
               {
                  this.isSetingMovieClip = so.data["isSetingMovieClip"];
               }
               if(so.data["propLayerMode"] != undefined)
               {
                  this._propLayerMode = so.data["propLayerMode"];
               }
               if(so.data["autoCaddy"] != undefined)
               {
                  this._autoCaddy = so.data["autoCaddy"];
               }
               if(so.data["autoOfferPack"] != undefined)
               {
                  this._autoOfferPack = so.data["autoOfferPack"];
               }
               if(so.data["autoBead"] != undefined)
               {
                  this._autoBead = so.data["autoBead"];
               }
               if(so.data["edictumVersion"] != undefined)
               {
                  this._edictumVersion = so.data["edictumVersion"];
               }
               if(so.data["stoneFriend"] != undefined)
               {
                  this.stoneFriend = so.data["stoneFriend"];
               }
               if(so.data["hasStrength3"] != undefined)
               {
                  for(key in so.data["hasStrength3"])
                  {
                     this.hasStrength3[key] = so.data["hasStrength3"][key];
                  }
               }
               if(so.data["recentContactsID"] != undefined)
               {
                  for(keyII in so.data["recentContactsID"])
                  {
                     this.recentContactsID[keyII] = so.data["recentContactsID"][keyII];
                  }
               }
               if(so.data["voteData"] != undefined)
               {
                  for(keyIII in so.data["voteData"])
                  {
                     this.voteData[keyIII] = so.data["voteData"][keyIII];
                  }
               }
               if(so.data["spacialReadedMail"] != undefined)
               {
                  for(keyIV in so.data["spacialReadedMail"])
                  {
                     this.spacialReadedMail[keyIV] = so.data["spacialReadedMail"][keyIV];
                  }
               }
               if(so.data["deleteMail"] != undefined)
               {
                  for(keyV in so.data["deleteMail"])
                  {
                     this.deleteMail[keyV] = so.data["deleteMail"][keyV];
                  }
               }
               if(so.data["privateChatRecord"] != undefined)
               {
                  for(keyP in so.data["privateChatRecord"])
                  {
                     this.privateChatRecord[keyP] = so.data["privateChatRecord"][keyP];
                  }
               }
               if(so.data["GameKeySets"] != undefined)
               {
                  i = 1;
                  while(i < KEY_SET_ABLE.length + 1)
                  {
                     this.GameKeySets[String(i)] = so.data["GameKeySets"][String(i)];
                     i++;
                  }
               }
               else
               {
                  j = 0;
                  while(j < KEY_SET_ABLE.length)
                  {
                     this.GameKeySets[String(j + 1)] = KEY_SET_ABLE[j];
                     j++;
                  }
               }
               if(so.data["AuctionInfos"] != undefined)
               {
                  for(k in so.data["AuctionInfos"])
                  {
                     this.AuctionInfos[k] = so.data["AuctionInfos"][k];
                  }
               }
               if(so.data["AuctionIDs"] != undefined)
               {
                  this.AuctionIDs = so.data["AuctionIDs"];
                  for(id in so.data["AuctionInfos"])
                  {
                     this.AuctionIDs[id] = so.data["AuctionInfos"][id];
                  }
               }
               if(so.data["setBagLocked" + PlayerManager.Instance.Self.ID] != undefined)
               {
                  this.setBagLocked = so.data["setBagLocked"];
               }
               if(so.data["deadtip"] != undefined)
               {
                  this.deadtip = so.data["deadtip"];
               }
               if(so.data["StoreBuyInfo"] != undefined)
               {
                  for(key1 in so.data["StoreBuyInfo"])
                  {
                     this.StoreBuyInfo[key1] = so.data["StoreBuyInfo"][key1];
                  }
               }
               if(so.data["hasEnteredFightLib"] != undefined)
               {
                  for(key2 in so.data["hasEnteredFightLib"])
                  {
                     this.hasEnteredFightLib[key2] = so.data["hasEnteredFightLib"][key2];
                  }
               }
               if(so.data["isAffirm"] != this.isAffirm)
               {
                  this.isAffirm = so.data["isAffirm"];
               }
               if(so.data["fastReplys"] != undefined)
               {
                  for(key3 in so.data["fastReplys"])
                  {
                     this.fastReplys[key3] = so.data["fastReplys"][key3];
                  }
               }
               if(so.data["autoSnsSend"] != undefined)
               {
                  this._autoSnsSend = so.data["autoSnsSend"];
               }
               if(so.data["allowSnsSend"] != undefined)
               {
                  this._allowSnsSend = so.data["allowSnsSend"];
               }
               if(so.data["AwayAutoReply"] != undefined)
               {
                  for(key4 in so.data["AwayAutoReply"])
                  {
                     this.awayAutoReply[key4] = so.data["AwayAutoReply"][key4];
                  }
               }
               if(so.data["BusyAutoReply"] != undefined)
               {
                  for(key5 in so.data["BusyAutoReply"])
                  {
                     this.busyAutoReply[key5] = so.data["BusyAutoReply"][key5];
                  }
               }
               if(so.data["NoDistrubAutoReply"] != undefined)
               {
                  for(key6 in so.data["NoDistrubAutoReply"])
                  {
                     this.noDistrubAutoReply[key6] = so.data["NoDistrubAutoReply"][key6];
                  }
               }
               if(so.data["ShoppingAutoReply"] != undefined)
               {
                  for(key7 in so.data["ShoppingAutoReply"])
                  {
                     this.shoppingAutoReply[key7] = so.data["ShoppingAutoReply"][key7];
                  }
               }
               if(so.data["isCommunity"] != undefined)
               {
                  this.isCommunity = so.data["isCommunity"];
               }
               if(so.data["autoWish"] != undefined)
               {
                  this.autoWish = so.data["autoWish"];
               }
               if(so.data["halliconExperienceStep"] != undefined)
               {
                  this.halliconExperienceStep = so.data["halliconExperienceStep"];
               }
            }
            return;
         }
         catch(e:Error)
         {
            return;
         }
         finally
         {
            this.changed();
         }
      }
      
      public function save() : void
      {
         var _loc1_:SharedObject = null;
         var _loc2_:Object = null;
         var _loc3_:* = null;
         try
         {
            _loc1_ = SharedObject.getLocal("road");
            _loc1_.data["allowMusic"] = this.allowMusic;
            _loc1_.data["allowSound"] = this.allowSound;
            _loc1_.data["showTopMessageBar"] = this.showTopMessageBar;
            _loc1_.data["showInvateWindow"] = this.showInvateWindow;
            _loc1_.data["showParticle"] = this.showParticle;
            _loc1_.data["showOL"] = this.showOL;
            _loc1_.data["showCI"] = this.showCI;
            _loc1_.data["showHat"] = this.showHat;
            _loc1_.data["showGlass"] = this.showGlass;
            _loc1_.data["showSuit"] = this.showSuit;
            _loc1_.data["musicVolumn"] = this.musicVolumn;
            _loc1_.data["soundVolumn"] = this.soundVolumn;
            _loc1_.data["KeyAutoSnap"] = this.KeyAutoSnap;
            _loc1_.data["giftFirstShow"] = this.giftFirstShow;
            _loc1_.data["cardSystemShow"] = this.cardSystemShow;
            _loc1_.data["texpSystemShow"] = this.texpSystemShow;
            _loc1_.data["divorceBoolean"] = this.divorceBoolean;
            _loc1_.data["friendBrithdayName"] = this.friendBrithdayName;
            _loc1_.data["AutoReady"] = this.AutoReady;
            _loc1_.data["ShowBattleGuide"] = this.ShowBattleGuide;
            _loc1_.data["isHintPropExpire"] = this.isHintPropExpire;
            _loc1_.data["hasCheckedOverFrameRate"] = this.hasCheckedOverFrameRate;
            _loc1_.data["isAffirm"] = this.isAffirm;
            _loc1_.data["isRecommend"] = this.isRecommend;
            _loc1_.data["recommendNum"] = this.recommendNum;
            _loc1_.data["isSetingMovieClip"] = this.isSetingMovieClip;
            _loc1_.data["propLayerMode"] = this.propLayerMode;
            _loc1_.data["autoCaddy"] = this._autoCaddy;
            _loc1_.data["autoOfferPack"] = this._autoOfferPack;
            _loc1_.data["autoBead"] = this._autoBead;
            _loc1_.data["edictumVersion"] = this._edictumVersion;
            _loc1_.data["stoneFriend"] = this.stoneFriend;
            _loc2_ = {};
            for(_loc3_ in this.GameKeySets)
            {
               _loc2_[_loc3_] = this.GameKeySets[_loc3_];
            }
            _loc1_.data["GameKeySets"] = _loc2_;
            if(this.AuctionInfos)
            {
               _loc1_.data["AuctionInfos"] = this.AuctionInfos;
            }
            if(this.hasStrength3)
            {
               _loc1_.data["hasStrength3"] = this.hasStrength3;
            }
            if(this.recentContactsID)
            {
               _loc1_.data["recentContactsID"] = this.recentContactsID;
            }
            if(this.voteData)
            {
               _loc1_.data["voteData"] = this.voteData;
            }
            if(this.spacialReadedMail)
            {
               _loc1_.data["spacialReadedMail"] = this.spacialReadedMail;
            }
            if(this.deleteMail)
            {
               _loc1_.data["deleteMail"] = this.deleteMail;
            }
            if(this.privateChatRecord)
            {
               _loc1_.data["privateChatRecord"] = this.privateChatRecord;
            }
            if(this.hasEnteredFightLib)
            {
               _loc1_.data["hasEnteredFightLib"] = this.hasEnteredFightLib;
            }
            if(this.fastReplys)
            {
               _loc1_.data["fastReplys"] = this.fastReplys;
            }
            if(this.autoWish)
            {
               _loc1_.data["autoWish"] = this.autoWish;
            }
            _loc1_.data["AuctionIDs"] = this.AuctionIDs;
            _loc1_.data["setBagLocked"] = this.setBagLocked;
            _loc1_.data["deadtip"] = this.deadtip;
            _loc1_.data["StoreBuyInfo"] = this.StoreBuyInfo;
            _loc1_.data["autoSnsSend"] = this._autoSnsSend;
            _loc1_.data["allowSnsSend"] = this._allowSnsSend;
            _loc1_.data["AwayAutoReply"] = this.awayAutoReply;
            _loc1_.data["BusyAutoReply"] = this.busyAutoReply;
            _loc1_.data["NoDistrubAutoReply"] = this.noDistrubAutoReply;
            _loc1_.data["ShoppingAutoReply"] = this.shoppingAutoReply;
            _loc1_.data["isCommunity"] = this.isCommunity;
            _loc1_.data["halliconExperienceStep"] = this.halliconExperienceStep;
            _loc1_.flush(20 * 1024 * 1024);
         }
         catch(e:Error)
         {
         }
         this.changed();
      }
      
      public function changed() : void
      {
         var _loc1_:* = null;
         SoundManager.instance.setConfig(this.allowMusic,this.allowSound,this.musicVolumn,this.soundVolumn);
         for(_loc1_ in this.GameKeySets)
         {
            if(RIGHT_PROP[int(int(_loc1_) - 1)])
            {
               RIGHT_PROP[int(int(_loc1_) - 1)] = this.GameKeySets[_loc1_];
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set propTransparent(param1:Boolean) : void
      {
         if(this._propTransparent != param1)
         {
            this._propTransparent = param1;
            dispatchEvent(new SharedEvent(SharedEvent.TRANSPARENTCHANGED));
         }
      }
      
      public function get propTransparent() : Boolean
      {
         return this._propTransparent;
      }
   }
}
