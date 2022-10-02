package ddt.manager
{
   import calendar.CalendarManager;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import ddt.data.BuffType;
   import ddt.data.FightBuffInfo;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   
   public class BuffManager
   {
      
      private static var _buffTemplateInfo:Dictionary = new Dictionary();
      
      private static var _templateInfoLoaded:Boolean = false;
      
      private static var _effectLoaded:Boolean = false;
       
      
      public function BuffManager()
      {
         super();
      }
      
      public static function creatBuff(param1:int) : FightBuffInfo
      {
         var _loc2_:FightBuffInfo = new FightBuffInfo(param1);
         if(BuffType.isLocalBuffByID(param1))
         {
            _loc2_.type = BuffType.Local;
            translateDisplayID(_loc2_);
            if(BuffType.isLuckyBuff(param1) && CalendarManager.getInstance().luckyNum >= 0)
            {
               _loc2_.displayid = CalendarManager.getInstance().luckyNum + 40;
            }
         }
         else
         {
            _loc2_.displayid = _loc2_.id;
         }
         return _loc2_;
      }
      
      private static function translateDisplayID(param1:FightBuffInfo) : void
      {
         switch(param1.id)
         {
            case BuffType.AddPercentDamage:
               param1.displayid = BuffType.AddDamage;
               break;
            case BuffType.SetDefaultDander:
               param1.displayid = BuffType.TurnAddDander;
               break;
            case BuffType.AddDander:
               param1.displayid = BuffType.TurnAddDander;
               break;
            default:
               param1.displayid = param1.id;
         }
      }
      
      public static function startLoadBuffEffect() : void
      {
         var _loc1_:BuffTemplateInfo = null;
         var _loc2_:URLVariables = null;
         var _loc3_:BaseLoader = null;
         if(!_effectLoaded)
         {
            if(_templateInfoLoaded)
            {
               for each(_loc1_ in _buffTemplateInfo)
               {
                  if(_loc1_.EffectPic)
                  {
                     LoaderManager.Instance.creatAndStartLoad(PathManager.solvePetSkillEffect(_loc1_.EffectPic),BaseLoader.MODULE_LOADER);
                  }
               }
               _effectLoaded = true;
            }
            else
            {
               _loc2_ = new URLVariables();
               _loc2_["rnd"] = Math.random();
               _loc3_ = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("PetSkillElementInfo.xml"),BaseLoader.TEXT_LOADER,_loc2_);
               _loc3_.addEventListener(LoaderEvent.COMPLETE,onComplete);
               LoaderManager.Instance.startLoad(_loc3_);
            }
         }
      }
      
      private static function onComplete(param1:LoaderEvent) : void
      {
         var _loc3_:XML = null;
         var _loc4_:XMLList = null;
         var _loc5_:XML = null;
         var _loc6_:BuffTemplateInfo = null;
         var _loc2_:BaseLoader = param1.loader;
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,onComplete);
         if(_loc2_.isSuccess)
         {
            _loc3_ = new XML(_loc2_.content);
            _loc4_ = _loc3_..item;
            for each(_loc5_ in _loc4_)
            {
               _loc6_ = new BuffTemplateInfo();
               _loc6_.ID = _loc5_.@ID;
               _loc6_.Name = _loc5_.@Name;
               _loc6_.Description = _loc5_.@Description;
               _loc6_.EffectPic = _loc5_.@EffectPic;
               _buffTemplateInfo[_loc6_.ID] = _loc6_;
            }
            _templateInfoLoaded = true;
            startLoadBuffEffect();
         }
      }
      
      public static function getBuffById(param1:int) : BuffTemplateInfo
      {
         return _buffTemplateInfo[param1];
      }
   }
}

class BuffTemplateInfo
{
    
   
   public var ID:int;
   
   public var Name:String;
   
   public var Description:String;
   
   public var EffectPic:String;
   
   function BuffTemplateInfo()
   {
      super();
   }
}
