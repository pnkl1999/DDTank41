package game.view.buff
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.BuffType;
   import ddt.data.FightBuffInfo;
   import ddt.data.FightContainerBuff;
   import ddt.display.BitmapLoaderProxy;
   import ddt.display.BitmapObject;
   import ddt.display.BitmapSprite;
   import ddt.manager.BitmapManager;
   import ddt.manager.PathManager;
   import ddt.view.tips.PropTxtTipInfo;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class BuffCell extends BitmapSprite implements ITipedDisplay
   {
       
      
      private var _info:FightBuffInfo;
      
      private var _bitmapMgr:BitmapManager;
      
      private var _tipData:PropTxtTipInfo;
      
      private var _loaderProxy:BitmapLoaderProxy;
      
      private var _txt:FilterFrameText;
      
      public function BuffCell(param1:BitmapObject = null, param2:Matrix = null, param3:Boolean = true, param4:Boolean = false)
      {
         this._tipData = new PropTxtTipInfo();
         super(param1,param2,false,true);
         this._bitmapMgr = BitmapManager.getBitmapMgr("GameView");
         this._tipData = new PropTxtTipInfo();
         this._tipData.color = 15790320;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("game.petskillBuff.numTxt");
         addChild(this._txt);
      }
      
      override public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         if(this._loaderProxy)
         {
            this._loaderProxy.dispose();
         }
         this._loaderProxy = null;
         this._info = null;
         this._tipData = null;
         this._bitmapMgr.dispose();
         this._bitmapMgr = null;
         this._info = null;
         ShowTipManager.Instance.removeTip(this);
         super.dispose();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function clearSelf() : void
      {
         ShowTipManager.Instance.removeTip(this);
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this._loaderProxy)
         {
            this._loaderProxy.dispose();
         }
         this._loaderProxy = null;
         bitmapObject = null;
         this._info = null;
      }
      
      public function setInfo(param1:FightBuffInfo) : void
      {
         if(this._loaderProxy)
         {
            this._loaderProxy.dispose();
         }
         this._loaderProxy = null;
         this._info = param1;
         this._tipData.property = this._info.name;
         this._tipData.detail = this._info.description;
         if(BuffType.isContainerBuff(this._info))
         {
            bitmapObject = this._bitmapMgr.getBitmap("asset.core.payBuffAssetFight");
         }
         else if(param1.type == BuffType.PET_BUFF)
         {
            this._loaderProxy = new BitmapLoaderProxy(PathManager.solvePetBuff(param1.buffPic),new Rectangle(0,0,32 / this.scaleX,32 / this.scaleY));
            addChild(this._loaderProxy);
            ShowTipManager.Instance.addTip(this);
         }
         else
         {
            bitmapObject = this._bitmapMgr.getBitmap("asset.game.buff" + this._info.displayid);
         }
         if(this._info.Count > 1)
         {
            addChild(this._txt);
            this._txt.text = this._info.Count.toString();
         }
         else if(contains(this._txt))
         {
            removeChild(this._txt);
         }
         if(BuffType.isLocalBuffByID(this._info.id) || BuffType.isContainerBuff(this._info))
         {
            ShowTipManager.Instance.addTip(this);
         }
      }
      
      public function get tipData() : Object
      {
         if(BuffType.isContainerBuff(this._info))
         {
            return FightContainerBuff(this._info).tipData;
         }
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
      }
      
      public function get tipDirctions() : String
      {
         return "7,6,5,1,6,4";
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return 6;
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 6;
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         if(BuffType.isContainerBuff(this._info))
         {
            return "core.PayBuffTip";
         }
         return "core.FightBuffTip";
      }
      
      public function set tipStyle(param1:String) : void
      {
      }
   }
}
