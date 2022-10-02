package ddt.manager
{
   import ddt.data.analyze.DungeonAnalyzer;
   import ddt.data.analyze.MapAnalyzer;
   import ddt.data.analyze.WeekOpenMapAnalyze;
   import ddt.data.map.DungeonInfo;
   import ddt.data.map.MapInfo;
   import ddt.data.map.OpenMapInfo;
   import flash.events.EventDispatcher;
   
   public class MapManager extends EventDispatcher
   {
      
      private static var _list:Vector.<MapInfo>;
      
      private static var _openList:Vector.<OpenMapInfo>;
      
      private static var _radomMapInfo:MapInfo;
      
      private static var _defaultDungeon:DungeonInfo;
      
      private static var _pveList:Vector.<DungeonInfo>;
      
      private static var _pvpList:Vector.<MapInfo>;
      
      private static var _pveLinkList:Array;
      
      private static var _pveAdvancedList:Array;
      
      private static var _pveBossList:Vector.<DungeonInfo>;
      
      private static var _pveExplrolList:Vector.<DungeonInfo>;
      
      private static var _pvpComplectiList:Vector.<MapInfo>;
      
      private static var _fightLibList:Vector.<DungeonInfo>;
      
      private static var _pveAcademyList:Vector.<DungeonInfo>;
      
      private static var _pveActivityList:Vector.<DungeonInfo>;
      
      public static const PVP_TRAIN_MAP:int = 1;
      
      public static const PVP_COMPECTI_MAP:int = 0;
      
      public static const PVE_EXPROL_MAP:int = 2;
      
      public static const PVE_BOSS_MAP:int = 3;
      
      public static const PVE_LINK_MAP:int = 4;
      
      public static const FIGHT_LIB:int = 5;
      
      public static const PVE_ACADEMY_MAP:int = 6;
      
      public static const PVE_ACTIVITY_MAP:int = 21;
      
      public static const PVE_ADVANCED_MAP:Array = [13, 14, 15, 16, 17, 18, 19];
      
      public static const PVE_SPECIAL_MAP:int = 23;
      
      public static const DOUBLE_SPECIAL1:int = 47;
      
      public static const DOUBLE_SPECIAL2:int = 48;
      
      public static const PVE_MAP:int = 5;
      
      public static const PVP_MAP:int = 6;
       
      
      public function MapManager()
      {
         super();
      }
      
      public static function getListByType(param1:int = 0) : *
      {
         if(param1 == PVP_TRAIN_MAP)
         {
            return _list;
         }
         if(param1 == PVE_MAP)
         {
            return _pveList;
         }
         if(param1 == PVE_LINK_MAP)
         {
            return _pveLinkList;
         }
         if(param1 == PVE_BOSS_MAP)
         {
            return _pveBossList;
         }
         if(param1 == PVE_EXPROL_MAP)
         {
            return _pveExplrolList;
         }
         if(param1 == PVP_COMPECTI_MAP)
         {
            return _pvpComplectiList;
         }
         if(param1 == PVP_MAP)
         {
            return _pvpList;
         }
         if(param1 == FIGHT_LIB)
         {
            return _fightLibList;
         }
         if(param1 == PVE_ACADEMY_MAP)
         {
            return _pveAcademyList;
         }
         if(param1 == PVE_ACTIVITY_MAP || param1 == PVE_SPECIAL_MAP || param1 == DOUBLE_SPECIAL1 || param1 == DOUBLE_SPECIAL2)
         {
            return _pveActivityList;
         }
         return null;
      }
      
      public static function getAdvancedList() : Array
      {
         return _pveAdvancedList;
      }
      
      public static function setup() : void
      {
      }
      
      public static function getPveActivityList() : Vector.<DungeonInfo>
      {
         return _pveActivityList;
      }
      
      public static function setupMapInfo(param1:MapAnalyzer) : void
      {
         _radomMapInfo = new MapInfo();
         _radomMapInfo.ID = 0;
         _radomMapInfo.isOpen = true;
         _radomMapInfo.canSelect = true;
         _radomMapInfo.Name = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
         _radomMapInfo.Description = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
         _list = param1.list;
         _pvpList = _list.slice();
         _radomMapInfo = new MapInfo();
         _radomMapInfo.ID = 0;
         _radomMapInfo.isOpen = true;
         _radomMapInfo.canSelect = true;
         _radomMapInfo.Name = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
         _radomMapInfo.Description = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
         _list.unshift(_radomMapInfo);
         _pvpComplectiList = new Vector.<MapInfo>();
         _pvpComplectiList.push(_radomMapInfo);
      }
      
      public static function setupDungeonInfo(param1:DungeonAnalyzer) : void
      {
         var _loc3_:DungeonInfo = null;
         _defaultDungeon = new DungeonInfo();
         _defaultDungeon.ID = 10000;
         _defaultDungeon.Description = LanguageMgr.GetTranslation("tank.manager.selectDuplicate");
         _defaultDungeon.isOpen = true;
         _defaultDungeon.Name = LanguageMgr.GetTranslation("tank.manager.selectDuplicate");
         _defaultDungeon.Type = 4;
         _defaultDungeon.Ordering = -1;
         _pveList = param1.list;
         _pveLinkList = [];
         _pveAdvancedList = [];
         _pveBossList = new Vector.<DungeonInfo>();
         _pveExplrolList = new Vector.<DungeonInfo>();
         _fightLibList = new Vector.<DungeonInfo>();
         _pveAcademyList = new Vector.<DungeonInfo>();
         _pveActivityList = new Vector.<DungeonInfo>();
         var _loc2_:int = 0;
         while(_loc2_ < _pveList.length)
         {
            _loc3_ = _pveList[_loc2_];
            if(MapManager.PVE_ADVANCED_MAP.indexOf(_loc3_.ID) != -1)
            {
               _pveAdvancedList.push(_loc3_);
            }
            else if(_loc3_.Type == PVE_LINK_MAP)
            {
               _pveLinkList.push(_loc3_);
            }
            else if(_loc3_.Type == PVE_BOSS_MAP)
            {
               _pveBossList.push(_loc3_);
            }
            else if(_loc3_.Type == PVE_EXPROL_MAP)
            {
               _pveExplrolList.push(_loc3_);
            }
            else if(_loc3_.Type == FIGHT_LIB)
            {
               _fightLibList.push(_loc3_);
            }
            else if(_loc3_.Type == PVE_ACADEMY_MAP)
            {
               _pveAcademyList.push(_loc3_);
            }
            else if(_loc3_.Type == PVE_ACTIVITY_MAP || _loc3_.Type == PVE_SPECIAL_MAP || _loc3_.Type == DOUBLE_SPECIAL1 || _loc3_.Type == DOUBLE_SPECIAL2)
            {
               _pveActivityList.push(_loc3_);
            }
            _loc2_++;
         }
         _pveLinkList.unshift(_defaultDungeon);
         _pveAdvancedList.unshift(_defaultDungeon);
         _pveBossList.unshift(_defaultDungeon);
      }
      
      public static function setupOpenMapInfo(param1:WeekOpenMapAnalyze) : void
      {
         _openList = param1.list;
         buildMap();
      }
      
      public static function buildMap() : void
      {
         var _loc1_:String = null;
         var _loc3_:MapInfo = null;
         if(_openList == null || _list == null || ServerManager.Instance.current == null)
         {
            return;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < _openList.length)
         {
            if(_openList[_loc2_].serverID == ServerManager.Instance.current.ID)
            {
               _loc1_ = _openList[_loc2_].maps;
            }
            _loc2_++;
         }
         if(_openList && _list)
         {
            for each(_loc3_ in _list)
            {
               if(_loc1_)
               {
                  _loc3_.isOpen = _loc1_.indexOf(String(_loc3_.ID)) > -1;
               }
            }
            _list.splice(_list.indexOf(_radomMapInfo),1);
            _list.unshift(_radomMapInfo);
         }
      }
      
      public static function isMapOpen(param1:int) : Boolean
      {
         return getMapInfo(param1).isOpen;
      }
      
      public static function getMapInfo(param1:Number) : MapInfo
      {
         var _loc2_:MapInfo = null;
         for each(_loc2_ in _list)
         {
            if(_loc2_.ID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getDungeonInfo(param1:int) : DungeonInfo
      {
         var _loc2_:DungeonInfo = null;
         for each(_loc2_ in _pveList)
         {
            if(_loc2_.ID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getByOrderingDungeonInfo(param1:int) : DungeonInfo
      {
         var _loc2_:DungeonInfo = null;
         for each(_loc2_ in _pveLinkList)
         {
            if(_loc2_.Ordering == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getByOrderingSpecialDungeonInfo(param1:int) : DungeonInfo
      {
         var _loc2_:DungeonInfo = null;
         for each(_loc2_ in _pveAcademyList)
         {
            if(_loc2_.Ordering == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getByOrderingAdvancedDungeonInfo(param1:int) : DungeonInfo
      {
         var _loc2_:DungeonInfo = null;
         for each(_loc2_ in _pveAdvancedList)
         {
            if(_loc2_.Ordering == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getFightLibList() : Vector.<DungeonInfo>
      {
         return _fightLibList;
      }
      
      public static function getMapName(param1:int) : String
      {
         var _loc2_:DungeonInfo = getDungeonInfo(param1);
         if(_loc2_)
         {
            return _loc2_.Name;
         }
         var _loc3_:MapInfo = getMapInfo(param1);
         if(_loc3_)
         {
            return _loc3_.Name;
         }
         return "";
      }
      
      public static function getByOrderingActivityDungeonInfo(param1:int) : DungeonInfo
      {
         var _loc2_:DungeonInfo = null;
         for each(_loc2_ in _pveActivityList)
         {
            if(_loc2_.Ordering == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getMapIsOpen(param1:int) : Boolean
      {
         return _openList.indexOf(param1) != -1;
      }
   }
}
