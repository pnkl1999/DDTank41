package gemstone
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.EventDispatcher;
   import gemstone.info.GemstListInfo;
   import gemstone.info.GemstonInitInfo;
   import gemstone.info.GemstoneAnalyze;
   import gemstone.info.GemstoneInfo;
   import gemstone.info.GemstoneStaticInfo;
   import gemstone.info.GemstoneUpGradeInfo;
   import gemstone.items.ExpBar;
   import gemstone.items.GemstoneContent;
   import gemstone.items.Item;
   
   public class GemstoneManager extends EventDispatcher
   {
      
      private static var _instance:GemstoneManager;
      
      public static const SuitPLACE:int = 11;
      
      public static const GlassPPLACE:int = 5;
      
      public static const HariPPLACE:int = 2;
      
      public static const FacePLACE:int = 3;
      
      public static const DecorationPLACE:int = 13;
      
      public static const ID1:int = 100001;
      
      public static const ID2:int = 100002;
      
      public static const ID3:int = 100003;
      
      public static const ID4:int = 100004;
      
      public static const ID5:int = 100005;
       
      
      private var _gemstoneFrame:GemstoneFrame;
      
      private var _stoneInfoList:Vector.<GemstoneInfo>;
      
      private var _stoneItemList:Vector.<Item>;
      
      private var _stoneContentGroupList:Array;
      
      private var _stoneContentList:Array;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _loader:BaseLoader;
      
      private var _redUrl:String;
      
      private var _bulUrl:String;
      
      private var _greUrl:String;
      
      private var _yelUrl:String;
      
      private var _purpleUrl:String;
      
      private var _upGradeList:Vector.<GemstoneUpGradeInfo>;
      
      public var redInfoList:Vector.<GemstoneStaticInfo>;
      
      public var bluInfoList:Vector.<GemstoneStaticInfo>;
      
      public var greInfoList:Vector.<GemstoneStaticInfo>;
      
      public var yelInfoList:Vector.<GemstoneStaticInfo>;
      
      public var purpleInfoList:Vector.<GemstoneStaticInfo>;
      
      public var curstatiDataList:Vector.<GemstoneStaticInfo>;
      
      public var curItem:GemstoneContent;
      
      public var curGemstoneUpInfo:GemstoneUpGradeInfo;
      
      private var _gInfoList:Object;
      
      public var suitList:Vector.<GemstListInfo>;
      
      public var glassList:Vector.<GemstListInfo>;
      
      public var hariList:Vector.<GemstListInfo>;
      
      public var faceList:Vector.<GemstListInfo>;
      
      public var decorationList:Vector.<GemstListInfo>;
      
      public var curMaxLevel:uint;
      
      public function GemstoneManager()
      {
         this.suitList = new Vector.<GemstListInfo>();
         this.glassList = new Vector.<GemstListInfo>();
         this.hariList = new Vector.<GemstListInfo>();
         this.faceList = new Vector.<GemstListInfo>();
         this.decorationList = new Vector.<GemstListInfo>();
         super();
         this._upGradeList = new Vector.<GemstoneUpGradeInfo>();
      }
      
      public static function get Instance() : GemstoneManager
      {
         if(_instance == null)
         {
            _instance = new GemstoneManager();
         }
         return _instance;
      }
      
      public function loaderData() : void
      {
         this._loader = LoaderManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("FightSpiritTemplateList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.loaderComplete);
      }
      
      private function compeleteHander(param1:GemstoneAnalyze) : void
      {
      }
      
      private function loaderComplete(param1:LoaderEvent) : void
      {
         var _loc5_:GemstoneStaticInfo = null;
         this.redInfoList = new Vector.<GemstoneStaticInfo>();
         this.bluInfoList = new Vector.<GemstoneStaticInfo>();
         this.greInfoList = new Vector.<GemstoneStaticInfo>();
         this.yelInfoList = new Vector.<GemstoneStaticInfo>();
         this.purpleInfoList = new Vector.<GemstoneStaticInfo>();
         this._gInfoList = new Vector.<GemstoneStaticInfo>();
         var _loc2_:XML = new XML(param1.loader.content);
         var _loc3_:int = _loc2_.item.length();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new GemstoneStaticInfo();
            _loc5_.id = _loc2_.item[_loc4_].@FightSpiritID;
            _loc5_.fightSpiritIcon = _loc2_.item[_loc4_].@FightSpiritIcon;
            _loc5_.attack = _loc2_.item[_loc4_].@Attack;
            _loc5_.level = _loc2_.item[_loc4_].@Level;
            _loc5_.luck = _loc2_.item[_loc4_].@Lucky;
            _loc5_.Exp = _loc2_.item[_loc4_].@Exp;
            _loc5_.agility = _loc2_.item[_loc4_].@Agility;
            _loc5_.defence = _loc2_.item[_loc4_].@Defence;
            _loc5_.blood = _loc2_.item[_loc4_].@Blood;
            this._gInfoList.push(_loc5_);
            if(_loc5_.id == ID1)
            {
               GemstoneManager.Instance.setRedUrl(_loc5_.fightSpiritIcon);
               this.redInfoList.push(_loc5_);
            }
            else if(_loc5_.id == ID2)
            {
               GemstoneManager.Instance.setBulUrl(_loc5_.fightSpiritIcon);
               this.bluInfoList.push(_loc5_);
            }
            else if(_loc5_.id == ID3)
            {
               GemstoneManager.Instance.setGreUrl(_loc5_.fightSpiritIcon);
               this.greInfoList.push(_loc5_);
            }
            else if(_loc5_.id == ID4)
            {
               GemstoneManager.Instance.setYelUrl(_loc5_.fightSpiritIcon);
               this.yelInfoList.push(_loc5_);
            }
            else if(_loc5_.id == ID5)
            {
               GemstoneManager.Instance.setPurpleUrl(_loc5_.fightSpiritIcon);
               this.purpleInfoList.push(_loc5_);
            }
            _loc4_++;
         }
         this.curMaxLevel = this.bluInfoList.length - 1;
      }
      
      public function initView() : GemstoneFrame
      {
         this._gemstoneFrame = ComponentFactory.Instance.creatCustomObject("gemstoneFrame");
         return this._gemstoneFrame;
      }
      
      public function initFrame(param1:GemstoneFrame) : void
      {
         this._gemstoneFrame = param1;
      }
      
      public function clearFrame() : void
      {
         this._gemstoneFrame = null;
      }
      
      public function upDataFitCount() : void
      {
         if(this._gemstoneFrame)
         {
            this._gemstoneFrame.upDatafitCount();
         }
      }
      
      public function get gemstoneFrame() : GemstoneFrame
      {
         return this._gemstoneFrame;
      }
      
      public function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_FIGHT_SPIRIT_UP,this.playerFigSpiritUp);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_SPIRIT_INIT,this.playerFigSpiritinit);
      }
      
      private function playerFigSpiritinit(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:GemstonInitInfo = null;
         var _loc6_:Array = null;
         var _loc7_:Vector.<GemstListInfo> = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:GemstListInfo = null;
         var _loc2_:Boolean = param1.pkg.readBoolean();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new GemstonInitInfo();
            _loc5_.userId = param1.pkg.readInt();
            _loc5_.figSpiritId = param1.pkg.readInt();
            _loc5_.figSpiritIdValue = param1.pkg.readUTF();
            _loc5_.equipPlace = param1.pkg.readInt();
            _loc6_ = this.rezArr(_loc5_.figSpiritIdValue);
            _loc7_ = new Vector.<GemstListInfo>();
            _loc8_ = 0;
            while(_loc8_ < 3)
            {
               _loc9_ = _loc6_[_loc8_].split(",");
               _loc10_ = new GemstListInfo();
               _loc10_.fightSpiritId = _loc5_.figSpiritId;
               _loc10_.level = _loc9_[0];
               _loc10_.exp = _loc9_[1];
               _loc10_.place = _loc9_[2];
               _loc7_.push(_loc10_);
               _loc8_++;
            }
            _loc5_.list = _loc7_;
            switch(_loc5_.equipPlace)
            {
               case SuitPLACE:
                  this.suitList = _loc7_;
                  break;
               case GlassPPLACE:
                  this.glassList = _loc7_;
                  break;
               case HariPPLACE:
                  this.hariList = _loc7_;
                  break;
               case FacePLACE:
                  this.faceList = _loc7_;
                  break;
               case DecorationPLACE:
                  this.decorationList = _loc7_;
            }
            _loc4_++;
         }
      }
      
      private function rezArr(param1:String) : Array
      {
         var _loc2_:Array = param1.split("|");
         return _loc2_;
      }
      
      protected function playerFigSpiritUp(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:GemstListInfo = null;
         var _loc2_:GemstoneUpGradeInfo = new GemstoneUpGradeInfo();
         _loc2_.isUp = param1.pkg.readBoolean();
         _loc2_.isMaxLevel = param1.pkg.readBoolean();
         _loc2_.isFall = param1.pkg.readBoolean();
         _loc2_.num = param1.pkg.readInt();
         var _loc3_:Vector.<GemstListInfo> = new Vector.<GemstListInfo>();
         var _loc4_:int = param1.pkg.readInt();
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new GemstListInfo();
            _loc6_.fightSpiritId = param1.pkg.readInt();
            _loc6_.level = param1.pkg.readInt();
            _loc6_.exp = param1.pkg.readInt();
            _loc6_.place = param1.pkg.readInt();
            _loc3_.push(_loc6_);
            _loc5_++;
         }
         _loc2_.equipPlace = param1.pkg.readInt();
         _loc2_.dir = param1.pkg.readInt();
         _loc2_.list = _loc3_;
         this.setGemstoneListInfo(_loc2_);
         if(this._gemstoneFrame)
         {
            this._gemstoneFrame.upDatafitCount();
            this._gemstoneFrame.gemstoneAction(_loc2_);
         }
      }
      
      public function loadGemstoneModule(param1:Function = null, param2:Array = null) : void
      {
         this._funcParams = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,param1);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GEMSTONE_SYS);
      }
      
      public function get expBar() : ExpBar
      {
         return this._gemstoneFrame.expBar;
      }
      
      public function getRedUrl() : String
      {
         return this._redUrl;
      }
      
      public function getYelUrl() : String
      {
         return this._yelUrl;
      }
      
      public function getPurpleUrl() : String
      {
         return this._purpleUrl;
      }
      
      public function getBulUrl() : String
      {
         return this._bulUrl;
      }
      
      public function getGreUrl() : String
      {
         return this._greUrl;
      }
      
      public function setRedUrl(param1:String) : void
      {
         this._redUrl = param1;
      }
      
      public function setYelUrl(param1:String) : void
      {
         this._yelUrl = param1;
      }
      
      public function setBulUrl(param1:String) : void
      {
         this._bulUrl = param1;
      }
      
      public function setGreUrl(param1:String) : void
      {
         this._greUrl = param1;
      }
      
      public function setPurpleUrl(param1:String) : void
      {
         this._purpleUrl = param1;
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.GEMSTONE_SYS)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      public function getSelfList(param1:int) : Vector.<GemstListInfo>
      {
         if(param1 == GemstoneManager.DecorationPLACE)
         {
            return this.decorationList;
         }
         if(param1 == GemstoneManager.FacePLACE)
         {
            return this.faceList;
         }
         if(param1 == GemstoneManager.GlassPPLACE)
         {
            return this.glassList;
         }
         if(param1 == GemstoneManager.HariPPLACE)
         {
            return this.hariList;
         }
         if(param1 == GemstoneManager.SuitPLACE)
         {
            return this.suitList;
         }
         return null;
      }
      
      public function getByPlayerInfoList(param1:int, param2:int) : Vector.<GemstListInfo>
      {
         var _loc4_:Vector.<GemstonInitInfo> = null;
         var _loc3_:PlayerInfo = PlayerManager.Instance.findPlayer(param2);
         if(_loc3_ is SelfInfo)
         {
            return this.getSelfList(param1);
         }
         _loc4_ = _loc3_.gemstoneList;
         if(this.getPlaceByGemstonInitInfo(param1,_loc4_))
         {
            return this.getPlaceByGemstonInitInfo(param1,_loc4_).list;
         }
         return null;
      }
      
      public function setGemstoneListInfo(param1:GemstoneUpGradeInfo) : void
      {
         if(param1.equipPlace == GemstoneManager.FacePLACE)
         {
            this.faceList = param1.list;
         }
         else if(param1.equipPlace == GemstoneManager.SuitPLACE)
         {
            this.suitList = param1.list;
         }
         else if(param1.equipPlace == GemstoneManager.GlassPPLACE)
         {
            this.glassList = param1.list;
         }
         else if(param1.equipPlace == GemstoneManager.DecorationPLACE)
         {
            this.decorationList = param1.list;
         }
         else if(param1.equipPlace == GemstoneManager.HariPPLACE)
         {
            this.hariList = param1.list;
         }
      }
      
      public function getPlaceByGemstonInitInfo(param1:int, param2:Vector.<GemstonInitInfo>) : GemstonInitInfo
      {
         if(!param2 || param2.length <= 0)
         {
            return null;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_].equipPlace == param1)
            {
               return param2[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
   }
}
