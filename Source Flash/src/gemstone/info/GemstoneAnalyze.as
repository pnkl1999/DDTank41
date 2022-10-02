package gemstone.info
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class GemstoneAnalyze extends DataAnalyzer
   {
       
      
      public var gInfoList:Vector.<GemstoneStaticInfo>;
      
      public function GemstoneAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc5_:GemstoneStaticInfo = null;
         this.gInfoList = new Vector.<GemstoneStaticInfo>();
         var _loc2_:XML = new XML(param1);
         var _loc3_:int = _loc2_.item.length();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new GemstoneStaticInfo();
            _loc5_.fightSpiritIcon = _loc2_.item.@FightSpiritID;
            _loc5_.fightSpiritIcon = _loc2_.item.@FightSpiritIcon;
            _loc5_.agility = _loc2_.item.@agility;
            _loc5_.level = _loc2_.item.@level;
            _loc5_.luck = _loc2_.item.@luck;
            _loc5_.Exp = _loc2_.item.@Exp;
            _loc5_.attack = _loc2_.item.@attack;
            _loc5_.defence = _loc2_.item.@defence;
            this.gInfoList.push(_loc5_);
            _loc4_++;
         }
      }
   }
}
