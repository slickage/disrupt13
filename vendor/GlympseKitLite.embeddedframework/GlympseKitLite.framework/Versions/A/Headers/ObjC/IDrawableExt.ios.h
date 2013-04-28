//------------------------------------------------------------------------------
//
// Copyright (c) 2012 Glympse Inc.  All rights reserved.
//
//------------------------------------------------------------------------------

#ifndef IDRAWABLEEXT_H__GLYMPSE__
#define IDRAWABLEEXT_H__GLYMPSE__

namespace Glympse 
{
 
/**
 * Extends IDrawable with the set of platform specific methods.
 */
/*O*public**/ struct IDrawableExt : public IDrawable
{
    public: virtual UIImage* getImage() = 0;    
};
    
/*C*/typedef O< IDrawableExt > GDrawableExt;/**/
    
}

#endif // !IDRAWABLEEXT_H__GLYMPSE__
