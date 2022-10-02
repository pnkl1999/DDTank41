package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.manager.BossBoxManager;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import road7th.data.DictionaryData;
   
   public class BoxTempInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var inventoryItemList:DictionaryData;
      
      private var _boxTemplateID:Dictionary;
      
      public var caddyBoxGoodsInfo:Vector.<BoxGoodsTempInfo>;
      
      public var caddyTempIDList:DictionaryData;
      
      public var beadTempInfoList:DictionaryData;
      
      public var exploitTemplateIDs:Dictionary;
      
      public function BoxTempInfoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc5_:BoxGoodsTempInfo = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:BoxGoodsTempInfo = null;
         var _loc10_:BoxGoodsTempInfo = null;
         var _loc11_:Array = null;
         var _loc2_:uint = getTimer();
         var _loc3_:XML = new XML(param1);
         var _loc4_:XMLList = _loc3_..Item;
         this.inventoryItemList = new DictionaryData();
         this.caddyTempIDList = new DictionaryData();
         this.beadTempInfoList = new DictionaryData();
         this.caddyBoxGoodsInfo = new Vector.<BoxGoodsTempInfo>();
         this._boxTemplateID = BossBoxManager.instance.boxTemplateID;
         this.exploitTemplateIDs = BossBoxManager.instance.exploitTemplateIDs;
         this.initDictionaryData();
         if(_loc3_.@value == "true")
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length())
            {
               _loc7_ = _loc4_[_loc6_].@ID;
               _loc8_ = _loc4_[_loc6_].@TemplateId;
               if(int(_loc7_) == EquipType.CADDY)
               {
                  _loc9_ = new BoxGoodsTempInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc9_,_loc4_[_loc6_]);
                  this.caddyBoxGoodsInfo.push(_loc9_);
                  this.caddyTempIDList.add(_loc9_.TemplateId,_loc9_);
               }
               else if(int(_loc7_) == EquipType.BEAD_ATTACK || int(_loc7_) == EquipType.BEAD_DEFENSE || int(_loc7_) == EquipType.BEAD_ATTRIBUTE)
               {
                  _loc10_ = new BoxGoodsTempInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc10_,_loc4_[_loc6_]);
                  this.beadTempInfoList[_loc7_].push(_loc10_);
               }
               if(this._boxTemplateID[_loc7_])
               {
                  _loc5_ = new BoxGoodsTempInfo();
                  _loc11_ = new Array();
                  ObjectUtils.copyPorpertiesByXML(_loc5_,_loc4_[_loc6_]);
                  this.inventoryItemList[_loc7_].push(_loc5_);
               }
               if(this.exploitTemplateIDs[_loc7_])
               {
                  _loc5_ = new BoxGoodsTempInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc5_,_loc4_[_loc6_]);
                  this.exploitTemplateIDs[_loc7_].push(_loc5_);
               }
               _loc6_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc3_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      private function initDictionaryData() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         for each(_loc1_ in this._boxTemplateID)
         {
            _loc2_ = new Array();
            this.inventoryItemList.add(_loc1_,_loc2_);
         }
         this.beadTempInfoList.add(EquipType.BEAD_ATTACK,new Vector.<BoxGoodsTempInfo>());
         this.beadTempInfoList.add(EquipType.BEAD_DEFENSE,new Vector.<BoxGoodsTempInfo>());
         this.beadTempInfoList.add(EquipType.BEAD_ATTRIBUTE,new Vector.<BoxGoodsTempInfo>());
      }
   }
}
