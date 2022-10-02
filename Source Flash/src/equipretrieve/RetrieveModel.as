package equipretrieve
{
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import store.StoreCell;
   
   public class RetrieveModel
   {
      
      public static const EmailX:int = 776;
      
      public static const EmailY:int = 572;
      
      private static var _instance:RetrieveModel;
       
      
      private var _CellsInfoArr:Array;
      
      private var _resultCell:Object;
      
      public var isFull:Boolean = false;
      
      private var _equipmentBag:BagInfo;
      
      public function RetrieveModel()
      {
         super();
      }
      
      public static function get Instance() : RetrieveModel
      {
         if(_instance == null)
         {
            _instance = new RetrieveModel();
         }
         return _instance;
      }
      
      public function start(param1:SelfInfo) : void
      {
         this._CellsInfoArr = new Array();
         this._CellsInfoArr = [null,null,null,null,null];
         this._equipmentBag = param1.Bag;
      }
      
      public function get equipmentBag() : BagInfo
      {
         return this._equipmentBag;
      }
      
      public function setSaveCells(param1:StoreCell, param2:int) : void
      {
         if(this._CellsInfoArr[param2] == null)
         {
            this._CellsInfoArr[param2] = new Object();
         }
         this._CellsInfoArr[param2].info = param1.info;
         this._CellsInfoArr[param2].oldx = param1.x;
         this._CellsInfoArr[param2].oldy = param1.y;
      }
      
      public function setSaveInfo(param1:InventoryItemInfo, param2:int) : void
      {
         this._CellsInfoArr[param2].info = param1;
      }
      
      public function setSavePlaceType(param1:InventoryItemInfo, param2:int) : void
      {
         if(param1.BagType == BagInfo.EQUIPBAG || param1.BagType == BagInfo.PROPBAG)
         {
            this._CellsInfoArr[param2].Place = param1.Place;
            this._CellsInfoArr[param2].BagType = param1.BagType;
         }
      }
      
      public function getSaveCells(param1:int) : Object
      {
         if(this._CellsInfoArr[param1].info)
         {
            this._CellsInfoArr[param1].info.Count = 1;
         }
         return this._CellsInfoArr[param1];
      }
      
      public function setresultCell(param1:Object) : void
      {
         if(this._resultCell == null)
         {
            this._resultCell = new Object();
         }
         this._resultCell.point = param1.point;
         this._resultCell.place = int(param1.place);
         this._resultCell.bagType = int(param1.bagType);
         this._resultCell.cell = param1.cell;
      }
      
      public function getresultCell() : Object
      {
         return this._resultCell;
      }
      
      public function replay() : void
      {
         this._CellsInfoArr = new Array();
         this._resultCell = new Object();
      }
   }
}
