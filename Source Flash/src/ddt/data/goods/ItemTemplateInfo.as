package ddt.data.goods
{
   import flash.events.EventDispatcher;
   
   public class ItemTemplateInfo extends EventDispatcher
   {
       
      
      public var TemplateID:int;
      
      public var CategoryID:Number;
      
      public var Name:String;
      
      public var Description:String;
      
      public var Attack:int;
      
      public var Defence:int;
      
      public var Luck:int;
      
      public var Agility:int;
      
      public var Level:Number;
      
      public var Pic:String = "prop.png";
      
      public var NeedLevel:Number;
      
      public var NeedSex:Number;
      
      public var AddTime:String;
      
      public var Gold:Number;
      
      public var Money:Number;
      
      public var Quality:int;
      
      public var PayType:int;
      
      public var BuyTyte:int;
      
      public var Price1:int;
      
      public var Value1:int;
      
      public var Agio1:Number;
      
      public var Price2:int;
      
      public var Value2:int;
      
      public var Agio2:Number;
      
      public var Price3:int;
      
      public var Value3:int;
      
      public var Agio3:Number;
      
      public var FusionType:int;
      
      public var FusionRate:int;
      
      public var FusionNeedRate:int;
      
      public var Sort:int;
      
      public var MaxCount:int;
      
      public var Property1:String;
      
      public var Property2:String;
      
      public var Property3:String;
      
      public var Property4:String;
      
      public var Property5:String;
      
      public var Property6:String;
      
      public var Property7:String;
      
      public var Property8:String;
      
      public var CanDrop:Boolean;
      
      public var CanDelete:Boolean;
      
      public var CanEquip:Boolean;
      
      public var CanUse:Boolean;
      
      public var CanStrengthen:Boolean;
      
      public var StrengthenTimes:int;
      
      public var CanCompose:Boolean;
      
      public var IsVouch:Boolean;
      
      public var BindType:int;
      
      public var Data:String;
      
      public var Hole:String;
      
      public var RefineryLevel:int;
      
      public var ReclaimType:int;
      
      public var ReclaimValue:int;
      
      public var CanRecycle:int;
      
      public var SuitId:int;
	  
	  public var ThingsFrom:String = "";
      
      public function ItemTemplateInfo()
      {
         super();
      }
      
      public function getStyleIndex() : String
      {
         return this.Property1;
      }
      
      public function getStyleClass() : String
      {
         return this.Property2;
      }
   }
}
