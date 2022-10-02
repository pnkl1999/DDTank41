package littleGame.character
{
   import ddt.data.EquipType;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.view.character.ILayer;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   
   public class LittleGameCharaterLoader
   {
      
      private static const HAIR_LAYER:int = 2;
      
      private static const EAR_LAYER:int = 3;
      
      private static var boyCloth:BitmapData;
      
      private static var girlCloth:BitmapData;
      
      private static var effect:BitmapData;
      
      private static var specialHeads:Vector.<BitmapData>;
       
      
      private var _playerInfo:PlayerInfo;
      
      private var _loaders:Vector.<LittleGameCharacterLayer>;
      
      private var _recordStyle:Array;
      
      private var _recordColor:Array;
      
      private var _head:BitmapData;
      
      private var _body:BitmapData;
      
      private var hasClothColor:Boolean = false;
      
      private var hasFaceColor:Boolean = false;
      
      private var _callBack:Function;
      
      public function LittleGameCharaterLoader(info:PlayerInfo, littleGameId:int = 1)
      {
         super();
         this._playerInfo = info;
         this._loaders = new Vector.<LittleGameCharacterLayer>();
         this._recordStyle = this._playerInfo.Style.split(",");
         this._recordColor = this._playerInfo.Colors.split(",");
         this.hasFaceColor = Boolean(this._recordColor[5]);
         this.hasClothColor = Boolean(this._recordColor[4]);
         this._loaders.push(new LittleGameCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[4].split("|")[0])),this._recordColor[4],this._playerInfo.Sex,littleGameId));
         this._loaders.push(new LittleGameCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[5].split("|")[0])),this._recordColor[5],this._playerInfo.Sex,littleGameId));
         this._loaders.push(new LittleGameCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[2].split("|")[0])),this._recordColor[2],this._playerInfo.Sex,littleGameId));
         this._loaders.push(new LittleGameCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[3].split("|")[0])),this._recordColor[3],this._playerInfo.Sex,littleGameId));
         if(effect == null)
         {
            this._loaders.push(new LittleGameCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[5].split("|")[0])),this._recordColor[5],this._playerInfo.Sex,littleGameId,EquipType.EFFECT,1));
         }
         if(specialHeads == null || this.hasFaceColor)
         {
            specialHeads = new Vector.<BitmapData>();
            this._loaders.push(new LittleGameCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[5].split("|")[0])),this._recordColor[5],this._playerInfo.Sex,littleGameId,EquipType.FACE,1));
            this._loaders.push(new LittleGameCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[5].split("|")[0])),this._recordColor[5],this._playerInfo.Sex,littleGameId,EquipType.FACE,2));
            this._loaders.push(new LittleGameCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[5].split("|")[0])),this._recordColor[5],this._playerInfo.Sex,littleGameId,EquipType.FACE,3));
         }
      }
      
      public function load(callBack:Function) : void
      {
         this._callBack = callBack;
         for(var i:int = 0; i < this._loaders.length; i++)
         {
            this._loaders[i].load(this.onComplete);
         }
      }
      
      private function onComplete(layer:ILayer) : void
      {
         var isAllLayerComplete:Boolean = true;
         for(var i:int = 0; i < this._loaders.length; i++)
         {
            if(!this._loaders[i].isComplete)
            {
               isAllLayerComplete = false;
            }
         }
         if(isAllLayerComplete)
         {
            this.drawCharacter();
            this.loadComplete();
         }
      }
      
      private function drawCharacter() : void
      {
         this._head = this.drawHeadByFace(1);
         if(this._playerInfo.Sex)
         {
            if(boyCloth)
            {
               if(!this.hasClothColor)
               {
                  this._body = boyCloth;
               }
               else
               {
                  this._body = new BitmapData(this._loaders[0].width,this._loaders[0].height,true,0);
                  this._body.draw(this._loaders[0],null,null,BlendMode.NORMAL);
               }
            }
            else
            {
               this._body = new BitmapData(this._loaders[0].width,this._loaders[0].height,true,0);
               this._body.draw(this._loaders[0],null,null,BlendMode.NORMAL);
               if(!this.hasClothColor)
               {
                  boyCloth = this._body;
               }
            }
         }
         else if(girlCloth)
         {
            if(!this.hasClothColor)
            {
               this._body = girlCloth;
            }
            else
            {
               this._body = new BitmapData(this._loaders[0].width,this._loaders[0].height,true,0);
               this._body.draw(this._loaders[0],null,null,BlendMode.NORMAL);
            }
         }
         else
         {
            this._body = new BitmapData(this._loaders[0].width,this._loaders[0].height,true,0);
            this._body.draw(this._loaders[0],null,null,BlendMode.NORMAL);
            if(!this.hasClothColor)
            {
               girlCloth = this._body;
            }
         }
         if(effect == null)
         {
            effect = new BitmapData(this._loaders[4].width,this._loaders[4].height,true,0);
            effect.draw(this._loaders[4],null,null,BlendMode.NORMAL);
         }
         if(specialHeads.length == 0)
         {
            if(!this.hasFaceColor)
            {
               specialHeads.push(this.drawHeadByFace(this._loaders.length - 3));
               specialHeads.push(this.drawHeadByFace(this._loaders.length - 2));
               specialHeads.push(this.drawHeadByFace(this._loaders.length - 1));
            }
         }
      }
      
      private function drawHeadByFace(faceLayer:int) : BitmapData
      {
         var head:BitmapData = new BitmapData(this._loaders[faceLayer].width,this._loaders[faceLayer].height,true,0);
         var layer:LittleGameCharacterLayer = this._loaders[faceLayer];
         head.draw(layer.getContent(),null,null,BlendMode.NORMAL);
         layer = this._loaders[LittleGameCharaterLoader.HAIR_LAYER];
         head.draw(layer.getContent(),null,null,BlendMode.NORMAL);
         layer = this._loaders[LittleGameCharaterLoader.EAR_LAYER];
         head.draw(layer.getContent(),null,null,BlendMode.NORMAL);
         return head;
      }
      
      public function getContent() : Vector.<BitmapData>
      {
         var result:Vector.<BitmapData> = new Vector.<BitmapData>();
         result.push(this._head);
         result.push(this._body);
         result.push(effect);
         if(this.hasFaceColor)
         {
            result.push(this.drawHeadByFace(this._loaders.length - 3));
            result.push(this.drawHeadByFace(this._loaders.length - 2));
            result.push(this.drawHeadByFace(this._loaders.length - 1));
         }
         else
         {
            result.push(specialHeads[0]);
            result.push(specialHeads[1]);
            result.push(specialHeads[2]);
         }
         return result;
      }
      
      private function loadComplete() : void
      {
         if(this._callBack != null)
         {
            this._callBack();
         }
      }
      
      public function dispose() : void
      {
         var layer:LittleGameCharacterLayer = null;
         for each(layer in this._loaders)
         {
            layer.dispose();
         }
         this._loaders == null;
         this._head = null;
         this._body = null;
         this._playerInfo = null;
      }
   }
}
