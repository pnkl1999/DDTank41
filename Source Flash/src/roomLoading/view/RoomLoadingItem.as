package roomLoading.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import room.events.RoomPlayerEvent;
   import room.model.RoomPlayer;
   
   public class RoomLoadingItem extends Sprite implements Disposeable
   {
      
      private static const COLORS:Array = ["blue","red"];
       
      
      private var _bg:Bitmap;
      
      private var _teamBg:ScaleFrameImage;
      
      private var _okIcon:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _loadingMc:MovieClip;
      
      private var _percTxt:FilterFrameText;
      
      private var _character:ShowCharacter;
      
      private var _figure:Sprite;
      
      private var _id:int;
      
      private var _info:RoomPlayer;
      
      public function RoomLoadingItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.roomLoading.blankBgAsset");
         addChild(this._bg);
      }
      
      public function set info(param1:RoomPlayer) : void
      {
         var _loc2_:Point = null;
         _loc2_ = null;
         var _loc3_:Point = null;
         this._info = param1;
         if(this._info)
         {
            this._teamBg = ComponentFactory.Instance.creatComponentByStylename("asset.roomLoading.loadingTeamBgAsset");
            addChild(this._teamBg);
            this._character = param1.character;
            this._info.character.y = 0;
            this._info.character.x = 0;
            this._character.showGun = false;
            this._character.show(false,-1);
            this._character.scaleX = -1;
            this._character.setShowLight(false,null);
            this._character.stopAnimation();
            this._figure = new Sprite();
            this._figure.x = 6;
            this._figure.y = 6;
            this._figure.addChild(this._character);
            this._figure.scrollRect = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.figureRect");
            if(this._info.playerInfo.getSuitsType() == 1)
            {
               _loc2_ = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.figurePos1");
            }
            else
            {
               _loc2_ = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.figurePos2");
            }
            this._character.x = _loc2_.x;
            this._character.y = _loc2_.y;
            addChild(this._figure);
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("roomloading.nameTxt");
            addChild(this._nameTxt);
            this._percTxt = ComponentFactory.Instance.creatComponentByStylename("roomloading.progressTxt");
            addChild(this._percTxt);
            this._nameTxt.text = String(this._info.playerInfo.NickName);
            this._percTxt.text = "0%";
            this._loadingMc = ComponentFactory.Instance.creat("asset.roomLoading.loadingMcAsset");
            addChild(this._loadingMc);
            _loc3_ = ComponentFactory.Instance.creatCustomObject("room.roomLoading.loadingPos");
            this._loadingMc.x = _loc3_.x;
            this._loadingMc.y = _loc3_.y;
            this._teamBg.setFrame(this._info.team);
            this._info.addEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__progress);
         }
      }
      
      public function get info() : RoomPlayer
      {
         return this._info;
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      private function __progress(param1:RoomPlayerEvent) : void
      {
         this._percTxt.text = String(int(this._info.progress)) + "%";
         if(this._info.progress > 99 && !this._okIcon)
         {
            this._okIcon = ComponentFactory.Instance.creatBitmap("asset.roomLoading.OKIconAsset");
            addChild(this._okIcon);
            this._percTxt.visible = false;
            this._loadingMc.visible = false;
         }
      }
      
      public function dispose() : void
      {
         if(this._info)
         {
            this._info.removeEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__progress);
         }
         this._info = null;
         if(this._character != null && this._figure != null && this._figure.contains(this._character))
         {
            this._figure.removeChild(this._character);
         }
         this._character = null;
         if(this._figure)
         {
            removeChild(this._figure);
         }
         this._figure = null;
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         ObjectUtils.disposeAllChildren(this);
         this._loadingMc = null;
         this._nameTxt = null;
         this._okIcon = null;
         this._percTxt = null;
         this._teamBg = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
