package dragonBones.textures
{
   import dragonBones.core.BaseObject;
   import dragonBones.core.DragonBones;
   import flash.geom.Rectangle;
   
   public class TextureData extends BaseObject
   {
      
      public var rotated:Boolean;
      
      public var name:String;
      
      public const region:Rectangle = new Rectangle();
      
      public var frame:Rectangle;
      
      public var parent:TextureAtlasData;
      
      public function TextureData(param1:TextureData)
      {
         super(this);
         if(param1 != this)
         {
            throw new Error(DragonBones.ABSTRACT_CLASS_ERROR);
         }
      }
      
      public static function generateRectangle() : Rectangle
      {
         return new Rectangle();
      }
      
      override protected function _onClear() : void
      {
         this.rotated = false;
         this.name = null;
         this.region.x = 0;
         this.region.y = 0;
         this.region.width = 0;
         this.region.height = 0;
         this.frame = null;
         this.parent = null;
      }
      
      public function copyFrom(param1:TextureData) : void
      {
         this.rotated = param1.rotated;
         this.name = param1.name;
         if(!this.frame && Boolean(param1.frame))
         {
            this.frame = TextureData.generateRectangle();
         }
         else if(Boolean(this.frame) && !param1.frame)
         {
            this.frame = null;
         }
         if(Boolean(this.frame) && Boolean(param1.frame))
         {
            this.frame.copyFrom(param1.frame);
         }
         this.parent = param1.parent;
         this.region.copyFrom(param1.region);
      }
   }
}

