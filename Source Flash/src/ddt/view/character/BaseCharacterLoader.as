package ddt.view.character
{
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.utils.MenoryUtil;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   
   public class BaseCharacterLoader implements ICharacterLoader
   {
       
      
      protected var _layers:Vector.<ILayer>;
      
      protected var _layerFactory:ILayerFactory;
      
      protected var _info:PlayerInfo;
      
      protected var _recordStyle:Array;
      
      protected var _recordColor:Array;
      
      protected var _content:BitmapData;
      
      private var _callBack:Function;
      
      private var _completeCount:int;
      
      protected var _wing:MovieClip;
      
      public function BaseCharacterLoader(param1:PlayerInfo)
      {
         this._wing = new MovieClip();
         super();
         this._info = param1;
      }
      
      protected function initLayers() : void
      {
         var _loc1_:ILayer = null;
         if(this._layers != null)
         {
            for each(_loc1_ in this._layers)
            {
               _loc1_.dispose();
            }
            this._layers = null;
         }
         this._layers = new Vector.<ILayer>();
         this._recordStyle = this._info.Style.split(",");
         this._recordColor = this._info.Colors.split(",");
         this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[7].split("|")[0])),this._info.Sex,this._recordColor[7],BaseLayer.SHOW));
         this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[1].split("|")[0])),this._info.Sex,this._recordColor[1],BaseLayer.SHOW));
         this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[0].split("|")[0])),this._info.Sex,this._recordColor[0],BaseLayer.SHOW));
         this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[3].split("|")[0])),this._info.Sex,this._recordColor[3],BaseLayer.SHOW));
         this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[4].split("|")[0])),this._info.Sex,this._recordColor[4],BaseLayer.SHOW));
         this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[2].split("|")[0])),this._info.Sex,this._recordColor[2],BaseLayer.SHOW,false,this._info.getHairType()));
         this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[5].split("|")[0])),this._info.Sex,this._recordColor[5],BaseLayer.SHOW));
         this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[6].split("|")[0])),this._info.Sex,this._recordColor[6],BaseLayer.SHOW));
         this._layers.push(this._layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[8].split("|")[0])),this._info.Sex,this._recordColor[8],BaseLayer.SHOW));
      }
      
      protected function getIndexByTemplateId(param1:String) : int
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
            case "7":
            case "27":
               return 7;
            default:
               return -1;
         }
      }
      
      public final function load(param1:Function = null) : void
      {
         var _loc4_:ILayer = null;
         this._callBack = param1;
         if(this._layerFactory == null || this._info == null || this._info.Style == null)
         {
            this.loadComplete();
            return;
         }
         this.initLayers();
         var _loc2_:int = this._layers.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._layers[_loc3_];
            _loc4_.load(this.__layerComplete);
            _loc3_++;
         }
      }
      
      public function getUnCompleteLog() : String
      {
         var _loc4_:ILayer = null;
         var _loc1_:String = "";
         if(this._layers == null)
         {
            return "_layers == null\n";
         }
         var _loc2_:int = this._layers.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._layers[_loc3_];
            if(!this._layers[_loc3_].isComplete)
            {
               _loc1_ += "unLoaded templete: " + this._layers[_loc3_].info.TemplateID.toString() + "\n";
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      private function __layerComplete(param1:ILayer) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < this._layers.length)
         {
            if(!this._layers[_loc3_].isComplete)
            {
               _loc2_ = false;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            this.drawCharacter();
            this.loadComplete();
         }
      }
      
      protected function loadComplete() : void
      {
         if(this._callBack != null)
         {
            this._callBack(this);
         }
      }
      
      protected function drawCharacter() : void
      {
         var _loc1_:Number = this._layers[1].width;
         var _loc2_:Number = this._layers[1].height;
         if(_loc1_ == 0 || _loc2_ == 0)
         {
            return;
         }
         if(this._content)
         {
            this._content.dispose();
         }
         this._content = new BitmapData(_loc1_,_loc2_,true,0);
         for(var _loc3_:int = this._layers.length - 1; _loc3_ >= 0; _loc3_--)
         {
            if(this._info.getShowSuits())
            {
               if(this._layers[_loc3_].info.CategoryID != EquipType.SUITS && this._layers[_loc3_].info.CategoryID != EquipType.WING && this._layers[_loc3_].info.CategoryID != EquipType.ARM)
               {
                  continue;
               }
            }
            else if(this._layers[_loc3_].info.CategoryID == EquipType.SUITS)
            {
               continue;
            }
            if(this._layers[_loc3_].info.CategoryID == EquipType.WING)
            {
               this._wing = this._layers[_loc3_].getContent() as MovieClip;
            }
            else
            {
               this._content.draw((this._layers[_loc3_] as ILayer).getContent(),null,null,BlendMode.NORMAL);
            }
         }
         MenoryUtil.clearMenory();
      }
      
      public function getContent() : Array
      {
         return [this._content,this._wing];
      }
      
      public function setFactory(param1:ILayerFactory) : void
      {
         this._layerFactory = param1;
      }
      
      public function update() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:ItemTemplateInfo = null;
         var _loc8_:ILayer = null;
         var _loc9_:ItemTemplateInfo = null;
         var _loc10_:ILayer = null;
         var _loc11_:int = 0;
         if(this._info.Style && this._layers)
         {
            _loc1_ = this._info.Style.split(",");
            _loc2_ = this._info.Colors.split(",");
            _loc3_ = false;
            _loc4_ = false;
            _loc5_ = 0;
            while(_loc5_ < _loc1_.length)
            {
               if(this._recordStyle == null)
               {
                  break;
               }
               if(_loc5_ >= this._recordStyle.length)
               {
                  break;
               }
               _loc6_ = this.getIndexByTemplateId(_loc1_[_loc5_].split("|")[0]);
               if(!(_loc6_ == -1 || _loc6_ == 9))
               {
                  if(this._recordStyle.indexOf(_loc1_[_loc5_]) == -1)
                  {
                     if(!_loc3_)
                     {
                        _loc3_ = _loc1_[_loc5_].charAt(0) == EquipType.HEAD;
                     }
                     if(!_loc4_)
                     {
                        _loc4_ = _loc1_[_loc5_].charAt(0) == EquipType.HAIR;
                     }
                     _loc7_ = ItemManager.Instance.getTemplateById(int(_loc1_[_loc5_].split("|")[0]));
                     _loc8_ = this.getCharacterLoader(_loc7_,_loc2_[_loc5_],_loc1_[_loc5_].split("|")[1]);
                     if(this._layers[_loc6_])
                     {
                        this._layers[_loc6_].dispose();
                     }
                     this._layers[_loc6_] = _loc8_;
                     _loc8_.load(this.__layerComplete);
                  }
                  else if(_loc2_[_loc5_] != null)
                  {
                     if(this._recordColor[_loc5_] != _loc2_[_loc5_])
                     {
                        this._layers[_loc6_].setColor(_loc2_[_loc5_]);
                     }
                  }
               }
               _loc5_++;
            }
            if(_loc3_ && !_loc4_)
            {
               _loc9_ = ItemManager.Instance.getTemplateById(this._info.getPartStyle(EquipType.HAIR));
               _loc10_ = this.getCharacterLoader(_loc9_,this._info.getPartColor(EquipType.HAIR));
               _loc11_ = this.getIndexByTemplateId(String(_loc9_.TemplateID));
               if(this._layers[_loc11_])
               {
                  this._layers[_loc11_].dispose();
               }
               this._layers[_loc11_] = _loc10_;
               _loc10_.load(this.__layerComplete);
            }
            this.__layerComplete(null);
            this._recordStyle = _loc1_;
            this._recordColor = _loc2_;
         }
      }
      
      protected function getCharacterLoader(param1:ItemTemplateInfo, param2:String = "", param3:String = null) : ILayer
      {
         if(param1.CategoryID == EquipType.HAIR)
         {
            return this._layerFactory.createLayer(param1,this._info.Sex,param2,BaseLayer.SHOW,false,this._info.getHairType(),param3);
         }
         return this._layerFactory.createLayer(param1,this._info.Sex,param2,BaseLayer.SHOW,false,1,param3);
      }
      
      public function dispose() : void
      {
         this._content = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._layers.length)
         {
            this._layers[_loc1_].dispose();
            _loc1_++;
         }
         this._wing = null;
         this._layers = null;
         this._layerFactory = null;
         this._info = null;
         this._callBack = null;
      }
   }
}
