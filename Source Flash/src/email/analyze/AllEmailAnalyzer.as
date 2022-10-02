package email.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import email.data.EmailInfo;
   import flash.utils.describeType;
   import road7th.utils.DateUtils;
   
   public class AllEmailAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:Array;
      
      public function AllEmailAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var ecInfo:XML = null;
         var icInfo:XML = null;
         var i:int = 0;
         var info:EmailInfo = null;
         var subXmllist:XMLList = null;
         var j:int = 0;
         var temp:InventoryItemInfo = null;
         var itemInfo:InventoryItemInfo = null;
         this._list = new Array();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml.Item;
            ecInfo = describeType(new EmailInfo());
            icInfo = describeType(new InventoryItemInfo());
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new EmailInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               subXmllist = xmllist[i].Item;
               for(j = 0; j < subXmllist.length(); j++)
               {
                  temp = new InventoryItemInfo();
                  ObjectUtils.copyPorpertiesByXML(temp,subXmllist[j]);
                  itemInfo = ItemManager.fill(temp);
                  info["Annex" + this.getAnnexPos(info,temp)] = temp;
				  temp.isGold = subXmllist[j].@IsGold == "true"?Boolean(true):Boolean(false);
				  temp.goldBeginTime = String(subXmllist[j].@GoldBeginTime);
				  temp.goldValidDate = int(subXmllist[j].@GoldVaild);
				  temp.latentEnergyCurStr = String(subXmllist[j].@AvatarPotentialProperty);
				  temp.latentEnergyEndTime = DateUtils.getDateByStr(String(subXmllist[j].@AvatarRemoveDate));
                  info.UserID = itemInfo.UserID;
               }
               if(!SharedManager.Instance.deleteMail[PlayerManager.Instance.Self.ID] || SharedManager.Instance.deleteMail[PlayerManager.Instance.Self.ID].indexOf(info.ID) < 0)
               {
                  this._list.push(info);
               }
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      public function get list() : Array
      {
         this._list.reverse();
         return this._list;
      }
      
      private function getAnnexPos(info:EmailInfo, itempInfo:InventoryItemInfo) : int
      {
         for(var i:uint = 1; i <= 5; i++)
         {
            if(info["Annex" + i + "ID"] == itempInfo.ItemID)
            {
               return i;
            }
         }
         return 1;
      }
   }
}
