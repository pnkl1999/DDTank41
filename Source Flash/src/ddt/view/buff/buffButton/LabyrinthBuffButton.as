package ddt.view.buff.buffButton
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.container.VBox;
   import ddt.data.BuffInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class LabyrinthBuffButton extends BuffButton
   {
       
      
      private var _labyrinthBuffTipView:LabyrinthBuffTipView;
      
      private var _helpViewShow:Boolean = false;
      
      public function LabyrinthBuffButton()
      {
         super("asset.core.LabyrinthBuffAsset");
         _tipDirctions = "7,4,5,1";
         this.initView();
      }
      
      private function initView() : void
      {
         info = new BuffInfo(BuffInfo.LABYRINTH_BUFF);
         info.description = LanguageMgr.GetTranslation("ddt.buffinfo.labyrinthBuffhelp");
         this.buttonMode = true;
         this.useHandCursor = true;
      }
      
      override protected function __onclick(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         super.__onclick(param1);
         if(!this._helpViewShow)
         {
            param1.stopImmediatePropagation();
            this._labyrinthBuffTipView = new LabyrinthBuffTipView();
            this._helpViewShow = true;
            _loc2_ = this.localToGlobal(new Point(this.x + this.width,this.y + this.height));
            _loc2_.x -= 252;
            PositionUtils.setPos(this._labyrinthBuffTipView,_loc2_);
            LayerManager.Instance.addToLayer(this._labyrinthBuffTipView,LayerManager.GAME_DYNAMIC_LAYER);
            stage.addEventListener(MouseEvent.CLICK,this.__closeChairChnnel);
         }
         else if(this._labyrinthBuffTipView)
         {
            this._labyrinthBuffTipView.dispose();
            this._labyrinthBuffTipView = null;
            this._helpViewShow = false;
         }
      }
      
      protected function __closeChairChnnel(param1:MouseEvent) : void
      {
         if(!this._labyrinthBuffTipView)
         {
            return;
         }
         if(!(param1.stageX >= this._labyrinthBuffTipView.x && param1.stageX <= this._labyrinthBuffTipView.x + this._labyrinthBuffTipView.width && param1.stageY >= this._labyrinthBuffTipView.y && param1.stageY <= this._labyrinthBuffTipView.y + this._labyrinthBuffTipView.height))
         {
            stage.removeEventListener(MouseEvent.CLICK,this.__closeChairChnnel);
            if(this._labyrinthBuffTipView)
            {
               this._labyrinthBuffTipView.dispose();
               this._labyrinthBuffTipView = null;
               this._helpViewShow = false;
            }
         }
      }
      
      private function checkIsVBoxChild(param1:*, param2:VBox) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.numChildren)
         {
            if(param1 == param2.getChildAt(_loc3_))
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      override public function dispose() : void
      {
         if(this._labyrinthBuffTipView)
         {
            this._labyrinthBuffTipView.dispose();
            this._labyrinthBuffTipView = null;
         }
         super.dispose();
      }
   }
}
