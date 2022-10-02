package ddt.view.character
{
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   
   public class GameCharacterLoader extends BaseCharacterLoader
   {
      
      public static var MALE_STATES:Array = [[1,1],[2,2],[3,3],[4,4],[5,5],[7,7],[8,8],[11,9]];
      
      public static var FEMALE_STATES:Array = [[1,1],[2,2],[3,3],[4,4],[5,5],[7,6],[9,8],[11,9]];
       
      
      private var _sp:Vector.<BitmapData>;
      
      private var _faceup:BitmapData;
      
      private var _face:BitmapData;
      
      private var _lackHpFace:Vector.<BitmapData>;
      
      private var _faceDown:BitmapData;
      
      private var _normalSuit:BitmapData;
      
      private var _lackHpSuit:BitmapData;
      
      public var specialType:int = -1;
      
      public var stateType:int = -1;
      
      public function GameCharacterLoader(param1:PlayerInfo)
      {
         super(param1);
      }
      
      public function get STATES_ENUM() : Array
      {
         if(_info.Sex)
         {
            return MALE_STATES;
         }
         return FEMALE_STATES;
      }
      
      override protected function initLayers() : void
      {
         var _loc1_:ILayer = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
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
         if(_info.getShowSuits())
         {
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[7].split("|")[0])),_info.Sex,_recordColor[7],BaseLayer.GAME));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[7].split("|")[0])),_info.Sex,_recordColor[7],BaseLayer.GAME,false,1,null,"1"));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[6].split("|")[0])),_info.Sex,_recordColor[6],BaseLayer.GAME,true,1,_recordStyle[6].split("|")[1]));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[8].split("|")[0])),_info.Sex,_recordColor[8],BaseLayer.GAME));
         }
         else
         {
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[1].split("|")[0])),_info.Sex,_recordColor[1],BaseLayer.GAME));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[0].split("|")[0])),_info.Sex,_recordColor[0],BaseLayer.GAME));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[3].split("|")[0])),_info.Sex,_recordColor[3],BaseLayer.GAME));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[4].split("|")[0])),_info.Sex,_recordColor[4],BaseLayer.GAME));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[2].split("|")[0])),_info.Sex,_recordColor[2],BaseLayer.GAME,false,_info.getHairType()));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[5].split("|")[0])),_info.Sex,_recordColor[5],BaseLayer.GAME));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[6].split("|")[0])),_info.Sex,_recordColor[6],BaseLayer.GAME,true,1,_recordStyle[6].split("|")[1]));
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[8].split("|")[0])),_info.Sex,_recordColor[8],BaseLayer.GAME));
            _loc2_ = this.STATES_ENUM;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[5].split("|")[0])),_info.Sex,_recordColor[5],LayerFactory.STATE,false,1,null,String(_loc2_[_loc3_][0])));
               _layers.push(_layerFactory.createLayer(null,_info.Sex,"",LayerFactory.SPECIAL_EFFECT,false,1,null,String(_loc2_[_loc3_][1])));
               _loc3_++;
            }
         }
      }
      
      override protected function getIndexByTemplateId(param1:String) : int
      {
         switch(param1.charAt(0))
         {
            case "1":
               if(param1.charAt(1) == String(3))
               {
                  return 0;
               }
               if(param1.charAt(1) == String(5))
               {
                  return 8;
               }
               return 1;
               break;
            case "2":
               return 0;
            case "3":
               return 4;
            case "4":
               return 3;
            case "5":
               return 4;
            case "6":
               return 5;
            case "7":
               return 7;
            default:
               return -1;
         }
      }
      
      override protected function drawCharacter() : void
      {
         if(_info.getShowSuits())
         {
            this.drawSuits();
         }
         else
         {
            this.drawNormal();
         }
      }
      
      private function drawSuits() : void
      {
         var _loc1_:Number = _layers[1].width;
         var _loc2_:Number = _layers[1].height;
         if(_loc1_ == 0 || _loc2_ == 0)
         {
            return;
         }
         if(this._normalSuit)
         {
            this._normalSuit.dispose();
         }
         this._normalSuit = new BitmapData(_loc1_,_loc2_,true,0);
         if(this._lackHpSuit)
         {
            this._lackHpSuit.dispose();
         }
         this._lackHpSuit = new BitmapData(_loc1_,_loc2_,true,0);
         this._normalSuit.draw((_layers[2] as ILayer).getContent(),null,null,BlendMode.NORMAL);
         this._lackHpSuit.draw((_layers[2] as ILayer).getContent(),null,null,BlendMode.NORMAL);
         this._normalSuit.draw((_layers[0] as ILayer).getContent(),null,null,BlendMode.NORMAL);
         this._lackHpSuit.draw((_layers[1] as ILayer).getContent(),null,null,BlendMode.NORMAL);
         _wing = _layers[3].getContent() as MovieClip;
      }
      
      private function drawNormal() : void
      {
         var _loc7_:BitmapData = null;
         var _loc8_:BitmapData = null;
         var _loc9_:BitmapData = null;
         var _loc10_:BitmapData = null;
         var _loc1_:Number = _layers[1].width;
         var _loc2_:Number = _layers[1].height;
         if(_loc1_ == 0 || _loc2_ == 0)
         {
            return;
         }
         if(this._face)
         {
            this._face.dispose();
         }
         this._face = new BitmapData(_loc1_,_loc2_,true,0);
         if(this._faceup)
         {
            this._faceup.dispose();
         }
         this._faceup = new BitmapData(_loc1_,_loc2_,true,0);
         if(this._sp)
         {
            for each(_loc7_ in this._sp)
            {
               _loc7_.dispose();
            }
         }
         this._sp = new Vector.<BitmapData>();
         if(this._lackHpFace)
         {
            for each(_loc8_ in this._lackHpFace)
            {
               _loc8_.dispose();
            }
         }
         this._lackHpFace = new Vector.<BitmapData>();
         if(this._faceDown)
         {
            this._faceDown.dispose();
         }
         this._faceDown = new BitmapData(_loc1_,_loc2_,true,0);
         var _loc3_:int = 7;
         while(_loc3_ >= 0)
         {
            if(_layers[_loc3_].info.CategoryID == EquipType.WING)
            {
               _wing = _layers[_loc3_].getContent() as MovieClip;
            }
            else if(_loc3_ == 5)
            {
               this._face.draw((_layers[_loc3_] as ILayer).getContent(),null,null,BlendMode.NORMAL);
            }
            else if(_loc3_ == 6)
            {
               this._faceDown.draw((_layers[_loc3_] as ILayer).getContent(),null,null,BlendMode.NORMAL);
            }
            else if(_loc3_ < 5)
            {
               this._faceup.draw((_layers[_loc3_] as ILayer).getContent(),null,null,BlendMode.NORMAL);
            }
            _loc3_--;
         }
         var _loc4_:Number = _layers[8].width;
         var _loc5_:Number = _layers[8].height;
         var _loc6_:int = 8;
         while(_loc6_ < _layers.length)
         {
            _loc9_ = new BitmapData(_loc4_,_loc5_,true,0);
            _loc10_ = new BitmapData(_loc4_,_loc5_,true,0);
            _loc9_.draw((_layers[_loc6_] as ILayer).getContent(),null,null,BlendMode.NORMAL);
            _loc10_.draw((_layers[_loc6_ + 1] as ILayer).getContent(),null,null,BlendMode.NORMAL);
            this._lackHpFace.push(_loc9_);
            this._sp.push(_loc10_);
            _loc6_ += 2;
         }
      }
      
      override public function getContent() : Array
      {
         return [_wing,this._sp,this._faceup,this._face,this._lackHpFace,this._faceDown,this._normalSuit,this._lackHpSuit];
      }
      
      override protected function getCharacterLoader(param1:ItemTemplateInfo, param2:String = "", param3:String = null) : ILayer
      {
         if(param1.CategoryID == EquipType.HAIR)
         {
            return _layerFactory.createLayer(param1,_info.Sex,param2,BaseLayer.GAME,false,_info.getHairType(),param3);
         }
         return _layerFactory.createLayer(param1,_info.Sex,param2,BaseLayer.GAME,false,1,param3);
      }
      
      override public function dispose() : void
      {
         this._sp = null;
         this._faceup = null;
         this._face = null;
         this._lackHpFace = null;
         this._faceDown = null;
         this._normalSuit = null;
         this._lackHpSuit = null;
         super.dispose();
      }
   }
}
