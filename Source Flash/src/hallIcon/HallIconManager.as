package hallIcon
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   import hallIcon.event.HallIconEvent;
   import hallIcon.info.HallIconInfo;
   import hallIcon.model.HallIconModel;
   import hallIcon.view.HallIcon;
   
   import worldboss.WorldBossManager;
   
   public class HallIconManager extends EventDispatcher
   {
      
      private static var _instance:HallIconManager;
       
      
      public var model:HallIconModel;
      
      public function HallIconManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : HallIconManager
      {
         if(_instance == null)
         {
            _instance = new HallIconManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.model = new HallIconModel();
         this.initEvent();
      }
      
      public function checkDefaultIconShow() : void
      {
         this.model.expblessedIsOpen = true;
         if(PlayerManager.Instance.Self.Grade < 30 && !PlayerManager.Instance.Self.IsVIP)
         {
            this.model.vipLvlIsOpen = true;
         }
         this.model.wonderFulPlayIsOpen = true;
         this.model.activityIsOpen = true;
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.addEventListener(PlayerManager.VIP_STATE_CHANGE,this.__vipLvlIsOpenHandler);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPlayerPropertyChange);
      }
      
      private function __vipLvlIsOpenHandler(evt:Event) : void
      {
         if(PlayerManager.Instance.Self.Grade < 30 && !PlayerManager.Instance.Self.IsVIP)
         {
            this.model.vipLvlIsOpen = true;
         }
         else
         {
            this.model.vipLvlIsOpen = false;
         }
         this.model.dataChange(HallIconEvent.UPDATE_LEFTICON_VIEW,new HallIconInfo(HallIconType.VIPLVL));
      }
      
      private function cacheRightIcon($icontype:String, $iconInfo:HallIconInfo) : void
      {
         if($iconInfo.isopen)
         {
            this.model.cacheRightIconDic[$icontype] = $iconInfo;
         }
         else if(this.model.cacheRightIconDic[$icontype])
         {
            delete this.model.cacheRightIconDic[$icontype];
         }
      }
      
      public function checkCacheRightIconShow() : void
      {
         this.model.dispatchEvent(new HallIconEvent(HallIconEvent.UPDATE_BATCH_RIGHTICON_VIEW));
      }
      
      public function executeCacheRightIconLevelLimit($icontype:String, $isCache:Boolean, $level:int = 0) : void
      {
         if($isCache)
         {
            this.model.cacheRightIconLevelLimit[$icontype] = $level;
         }
         else if(this.model.cacheRightIconLevelLimit[$icontype])
         {
            delete this.model.cacheRightIconLevelLimit[$icontype];
         }
      }
      
      private function __onPlayerPropertyChange(event:PlayerPropertyEvent) : void
      {
         var tempKey:* = null;
         var tempValue:int = 0;
         if(event.changedProperties["Grade"] && PlayerManager.Instance.Self.IsUpGrade)
         {
            for(tempKey in this.model.cacheRightIconLevelLimit)
            {
               tempValue = this.model.cacheRightIconLevelLimit[tempKey];
               if(PlayerManager.Instance.Self.Grade >= tempValue)
               {
                  this.updateSwitchHandler(tempKey,true);
                  delete this.model.cacheRightIconLevelLimit[tempKey];
               }
            }
         }
      }
      
      public function updateSwitchHandler($icontype:String, $isopen:Boolean, $timemsg:String = null, $num:int = -1) : void
      {
         var iconInfo:HallIconInfo = this.convertIconInfo($icontype,$isopen,$timemsg,$num);
         this.cacheRightIcon($icontype,iconInfo);
         this.model.dispatchEvent(new HallIconEvent(HallIconEvent.UPDATE_RIGHTICON_VIEW,iconInfo));
      }
      
      private function convertIconInfo($icontype:String, $isopen:Boolean, $timemsg:String, $num:int) : HallIconInfo
      {
         var halltype:int = 0;
         var orderid:int = 99;
		 var fightover:Boolean = false;
         switch($icontype)
         {
            case HallIconType.RINGSTATION:
               halltype = HallIcon.WONDERFULPLAY;
               orderid = 3;
               break;
            case HallIconType.LEAGUE:
               halltype = HallIcon.WONDERFULPLAY;
               orderid = 4;
               break;
            case HallIconType.BATTLE:
               halltype = HallIcon.WONDERFULPLAY;
               orderid = 5;
               break;
            case HallIconType.TRANSNATIONAL:
               halltype = HallIcon.WONDERFULPLAY;
               orderid = 6;
               break;
            case HallIconType.CONSORTIABATTLE:
               halltype = HallIcon.WONDERFULPLAY;
               orderid = 7;
               break;
            case HallIconType.CAMP:
               halltype = HallIcon.WONDERFULPLAY;
               orderid = 8;
               break;
            case HallIconType.FIGHTFOOTBALLTIME:
               halltype = HallIcon.WONDERFULPLAY;
               orderid = 9;
               break;
            case HallIconType.SEVENDOUBLE:
               halltype = HallIcon.WONDERFULPLAY;
               orderid = 10;
               break;
            case HallIconType.LITTLEGAMENOTE:
               halltype = HallIcon.WONDERFULPLAY;
               orderid = 11;
               break;
            case HallIconType.FLOWERGIVING:
               halltype = HallIcon.WONDERFULPLAY;
               orderid = 12;
               break;
            case HallIconType.ESCORT:
               halltype = HallIcon.WONDERFULPLAY;
               orderid = 13;
               break;
            case HallIconType.BURIED:
               halltype = HallIcon.WONDERFULPLAY;
               orderid = 14;
               break;
			case HallIconType.WORLDBOSSENTRANCE1:
				if (WorldBossManager.Instance.bossInfo)
				{
					fightover = WorldBossManager.Instance.bossInfo.fightOver;
				}
				halltype = HallIcon.WONDERFULPLAY;
				orderid = 15;
				break;
			case HallIconType.WANTSTRONG:
				if (WorldBossManager.Instance.bossInfo)
				{
					fightover = WorldBossManager.Instance.bossInfo.fightOver;
				}
				halltype = HallIcon.WONDERFULPLAY;
				orderid = 16;
				break;
			case HallIconType.WORLDBOSSENTRANCE4:
				if (WorldBossManager.Instance.bossInfo)
				{
					fightover = WorldBossManager.Instance.bossInfo.fightOver;
				}
				halltype = HallIcon.WONDERFULPLAY;
				orderid = 17;
				break;
            case HallIconType.ACCUMULATIVE_LOGIN:
               halltype = HallIcon.ACTIVITY;
               orderid = 1;
               break;
            case HallIconType.SEVENDAYTARGET:
               halltype = HallIcon.ACTIVITY;
               orderid = 2;
               break;
            case HallIconType.GODSROADS:
               halltype = HallIcon.ACTIVITY;
               orderid = 3;
               break;
            case HallIconType.LIMITACTIVITY:
               halltype = HallIcon.ACTIVITY;
               orderid = 4;
               break;
            case HallIconType.OLDPLAYERREGRESS:
               halltype = HallIcon.ACTIVITY;
               orderid = 5;
               break;
            case HallIconType.GROWTHPACKAGE:
               halltype = HallIcon.ACTIVITY;
               orderid = 6;
               break;
            case HallIconType.LEFTGUNROULETTE:
               halltype = HallIcon.ACTIVITY;
               orderid = 7;
               break;
            case HallIconType.GROUPPURCHASE:
               halltype = HallIcon.ACTIVITY;
               orderid = 8;
               break;
            case HallIconType.NEWCHICKENBOX:
               halltype = HallIcon.ACTIVITY;
               orderid = 9;
               break;
            case HallIconType.SUPERWINNER:
               halltype = HallIcon.ACTIVITY;
               orderid = 10;
               break;
			case HallIconType.LUCKSTAR:
				halltype = HallIcon.ACTIVITY;
				orderid = 11;
				break;
            case HallIconType.DICE:
               halltype = HallIcon.ACTIVITY;
               orderid = 12;
               break;
            case HallIconType.TREASUREHUNTING:
               halltype = HallIcon.ACTIVITY;
               orderid = 13;
               break;
			case HallIconType.GUILDMEMBERWEEK:
				halltype = HallIcon.ACTIVITY;
				orderid = 14;
				break;
            case HallIconType.PYRAMID:
               halltype = HallIcon.ACTIVITY;
               orderid = 15;
               break;
            case HallIconType.SYAH:
               halltype = HallIcon.ACTIVITY;
               orderid = 16;
               break;
            case HallIconType.MYSTERIOUROULETTE:
               halltype = HallIcon.ACTIVITY;
               orderid = 17;
               break;
            case HallIconType.CATCHBEAST:
               halltype = HallIcon.ACTIVITY;
               orderid = 18;
               break;
            case HallIconType.LANTERNRIDDLES:
               halltype = HallIcon.ACTIVITY;
               orderid = 19;
               break;
            case HallIconType.CHRISTMAS:
               halltype = HallIcon.ACTIVITY;
               orderid = 20;
               break;
            case HallIconType.LUCKSTONE:
               halltype = HallIcon.ACTIVITY;
               orderid = 21;
               break;
            case HallIconType.LIGHTROAD:
               halltype = HallIcon.ACTIVITY;
               orderid = 22;
               break;
            case HallIconType.ENTERTAINMENT:
               halltype = HallIcon.ACTIVITY;
               orderid = 23;
               break;
            case HallIconType.SALESHOP:
               halltype = HallIcon.ACTIVITY;
               orderid = 24;
               break;
            case HallIconType.KINGDIVISION:
               halltype = HallIcon.ACTIVITY;
               orderid = 25;
               break;
			case HallIconType.CHICKACTIVATION:
				halltype = HallIcon.ACTIVITY;
				orderid = 26;
				break;
            case HallIconType.DDPLAY:
               halltype = HallIcon.ACTIVITY;
               orderid = 27;
               break;
            case HallIconType.BOGUADVENTURE:
               halltype = HallIcon.ACTIVITY;
               orderid = 28;
            case HallIconType.HALLOWEEN:
               halltype = HallIcon.ACTIVITY;
               orderid = 29;
               break;
            case HallIconType.WITCHBLESSING:
               halltype = HallIcon.ACTIVITY;
               orderid = 29;
               break;
            case HallIconType.TREASUREPUZZLE:
               halltype = HallIcon.ACTIVITY;
               orderid = 29;
               break;
            case HallIconType.WORSHIPTHEMOON:
               halltype = HallIcon.ACTIVITY;
               orderid = 30;
               break;
            case HallIconType.FOODACTIVITY:
               halltype = 3;
               orderid = 31;
               break;
            case HallIconType.RESCUE:
               halltype = HallIcon.ACTIVITY;
               orderid = 32;
               break;
            case HallIconType.CATCHINSECT:
               halltype = HallIcon.ACTIVITY;
               orderid = 33;
               break;
            case HallIconType.MAGPIEBRIDGE:
               halltype = HallIcon.ACTIVITY;
               orderid = 34;
               break;
            case HallIconType.CLOUDBUYLOTTERY:
               halltype = HallIcon.ACTIVITY;
               orderid = 35;
               break;
            case HallIconType.TREASURELOST:
               halltype = HallIcon.ACTIVITY;
               orderid = 32;
			   break;
         }
         var iconInfo:HallIconInfo = new HallIconInfo();
         iconInfo.halltype = halltype;
         iconInfo.icontype = $icontype;
         iconInfo.isopen = $isopen;
         iconInfo.timemsg = $timemsg;
         iconInfo.fightover = fightover;
         iconInfo.orderid = orderid;
         iconInfo.num = $num;
         return iconInfo;
      }
      
      public function showCommonFrame($content:DisplayObject, $titleLink:String = "", $width:Number = 530, $height:Number = 545) : Frame
      {
         var _frame:Frame = ComponentFactory.Instance.creatCustomObject("hallIcon.commonFrame");
         _frame.titleText = LanguageMgr.GetTranslation($titleLink);
         _frame.width = $width;
         _frame.height = $height;
         _frame.addToContent($content);
         _frame.addEventListener(FrameEvent.RESPONSE,this.__commonFrameResponse);
         LayerManager.Instance.addToLayer(_frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
         return _frame;
      }
      
      private function __commonFrameResponse(evt:FrameEvent) : void
      {
         var _frame:Frame = evt.currentTarget as Frame;
         if(_frame)
         {
            _frame.removeEventListener(FrameEvent.RESPONSE,this.__commonFrameResponse);
            ObjectUtils.disposeAllChildren(_frame);
            ObjectUtils.disposeObject(_frame);
            _frame = null;
         }
      }
      
      public function checkHallIconExperienceTask($isCompleted:Boolean = true) : void
      {
         if($isCompleted)
         {
            this.model.cacheRightIconTask = null;
         }
         else
         {
            this.model.cacheRightIconTask = {"isCompleted":$isCompleted};
         }
         dispatchEvent(new HallIconEvent(HallIconEvent.CHECK_HALLICONEXPERIENCEOPEN));
      }
      
      public function checkCacheRightIconTask() : void
      {
         if(this.model.cacheRightIconTask)
         {
            dispatchEvent(new HallIconEvent(HallIconEvent.CHECK_HALLICONEXPERIENCEOPEN,this.model.cacheRightIconTask.isCompleted));
         }
      }
   }
}
