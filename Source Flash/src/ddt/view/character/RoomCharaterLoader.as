package ddt.view.character
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.display.Shape;
   
   public class RoomCharaterLoader extends BaseCharacterLoader
   {
       
      
      private var _suit:BitmapData;
      
      private var _faceUpBmd:BitmapData;
      
      private var _faceBmd:BitmapData;
      
      public var showWeapon:Boolean;
      
      public function RoomCharaterLoader(param1:PlayerInfo)
      {
         super(param1);
      }
      
      override protected function initLayers() : void
      {
         var _loc1_:ILayer = null;
         if(_layers != null)
         {
            for each(_loc1_ in _layers)
            {
               _loc1_.dispose();
            }
            _layers = null;
         }
         _layers = new Vector.<ILayer>();
         _recordStyle = _info.Style.split(",");
         _recordColor = _info.Colors.split(",");
         this.loadPart(7);
         this.loadPart(1);
         this.loadPart(0);
         this.loadPart(3);
         this.loadPart(4);
         this.loadPart(2);
         this.loadPart(5);
         this.laodArm();
         this.loadPart(8);
      }
      
      override protected function getIndexByTemplateId(param1:String) : int
      {
         var _loc2_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(int(param1));
         if(_loc2_ == null)
         {
            return -1;
         }
         switch(_loc2_.CategoryID.toString())
         {
            case "1":
            case "10":
            case "11":
            case "12":
               return 2;
            case "13":
               return 0;
            case "15":
               return 8;
            case "16":
               return 9;
            case "17":
               return -1;
            case "2":
               return 1;
            case "3":
               return 5;
            case "4":
               return 3;
            case "5":
               return 4;
            case "6":
               return 6;
            case "27":
            case "7":
               return 7;
            default:
               return -1;
         }
      }
      
      private function loadPart(param1:int) : void
      {
         if(_recordStyle[param1].split("|")[0] > 0)
         {
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[param1].split("|")[0])),_info.Sex,_recordColor[param1],BaseLayer.SHOW,param1 == 2,_info.getHairType()));
         }
      }
      
      private function laodArm() : void
      {
         if(_recordStyle[6].split("|")[0] > 0)
         {
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[6].split("|")[0])),_info.Sex,_recordColor[6],BaseLayer.SHOW,false,_info.getHairType(),_recordStyle[6].split("|")[1]));
         }
      }
      
      override protected function drawCharacter() : void
      {
         var _loc3_:Shape = null;
         var _loc4_:BitmapData = null;
         var _loc1_:Number = ShowCharacter.BIG_WIDTH;
         var _loc2_:Number = ShowCharacter.BIG_HEIGHT;
         if(_loc1_ == 0 || _loc2_ == 0)
         {
            return;
         }
         if(this._suit)
         {
            this._suit.dispose();
         }
         this._suit = new BitmapData(_loc1_ * 4,_loc2_,true,0);
         if(this._faceUpBmd)
         {
            this._faceUpBmd.dispose();
         }
         this._faceUpBmd = new BitmapData(_loc1_,_loc2_,true,0);
         if(this._faceBmd)
         {
            this._faceBmd.dispose();
         }
         this._faceBmd = new BitmapData(_loc1_ * 4,_loc2_,true,0);
         if(_info.getShowSuits())
         {
            this._suit.draw(_layers[0].getContent(),null,null,BlendMode.NORMAL);
            if(_info.WeaponID != 0 && _info.WeaponID != -1 && this.showWeapon)
            {
               _loc3_ = new Shape();
               _loc4_ = new BitmapData(_loc1_,_loc2_,true,0);
               _loc4_.draw(_layers[7].getContent());
               _loc3_.graphics.beginBitmapFill(_loc4_,null,true,true);
               _loc3_.graphics.drawRect(0,0,_loc1_ * 4,_loc2_);
               _loc3_.graphics.endFill();
               this._suit.draw(_loc3_,null,null,BlendMode.NORMAL);
               _loc4_.dispose();
            }
         }
         else
         {
            this._faceUpBmd.draw(_layers[5].getContent(),null,null,BlendMode.NORMAL);
            this._faceUpBmd.draw(_layers[4].getContent(),null,null,BlendMode.NORMAL);
            this._faceUpBmd.draw(_layers[3].getContent(),null,null,BlendMode.NORMAL);
            this._faceUpBmd.draw(_layers[2].getContent(),null,null,BlendMode.NORMAL);
            this._faceUpBmd.draw(_layers[1].getContent(),null,null,BlendMode.NORMAL);
            this._faceBmd.draw(_layers[6].getContent(),null,null,BlendMode.NORMAL);
            if(_info.WeaponID != 0 && _info.WeaponID != -1 && this.showWeapon)
            {
               this._faceUpBmd.draw(_layers[7].getContent(),null,null,BlendMode.NORMAL);
            }
         }
         _wing = _layers[8].getContent() as MovieClip;
      }
      
      override public function getContent() : Array
      {
         return [this._suit,this._faceUpBmd,this._faceBmd,_wing];
      }
   }
}
