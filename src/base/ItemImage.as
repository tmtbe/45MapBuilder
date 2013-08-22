package base 
{
	import base.ItemPosInfo;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author °无量
	 */	
	public class ItemImage extends Image 
	{
		public var itemPosInfo:ItemPosInfo;
		public function ItemImage(texture:Texture,itemPosInfo:ItemPosInfo)
		{
			super(texture);
			this.itemPosInfo = itemPosInfo;		
		}
}

}