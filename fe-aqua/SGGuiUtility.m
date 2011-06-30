/* X-Chat Aqua
 * Copyright (C) 2002 Steve Green
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA */

#import "SGGuiUtility.h"

@implementation SGGuiUtility 
/*
 + (NSPoint) centerRect:(NSRect) r
 onRect:(NSRect) rr
 inX:(BOOL) inX
 inY:(BOOL) inY
 {
 if (inX)
 r.origin.x = rr.origin.x + floor (rr.size.width - r.size.width) / 2;
 
 if (inY)
 r.origin.y = rr.origin.y + floor (rr.size.height - r.size.height) / 2;
 
 return r.origin;
 }
 */
+ (BOOL) trackButtonCell:(NSButtonCell *) cell
               withEvent:(NSEvent *) event
                  inRect:(NSRect) track_rect
             controlView:(NSView *) controlView
{
    for (;;)
    {
        NSPoint p = [controlView convertPoint:[event locationInWindow] fromView:nil];
        if (NSMouseInRect (p, track_rect, [controlView isFlipped]))
        {
            [cell highlight:YES withFrame:track_rect inView:controlView];
            [cell retain];
            BOOL triggered = [cell trackMouse:event inRect:track_rect ofView:controlView untilMouseUp:NO];
            [cell highlight:NO withFrame:track_rect inView:controlView];
            [cell release];
            if (triggered)
                return YES;
        }
        
        NSUInteger eventMask = NSLeftMouseDownMask | NSLeftMouseUpMask
                             | NSMouseMovedMask | NSLeftMouseDraggedMask | NSOtherMouseDraggedMask
                             | NSRightMouseDraggedMask;
        
        event = [NSApp nextEventMatchingMask:eventMask
                                   untilDate:nil
                                      inMode:NSEventTrackingRunLoopMode
                                     dequeue:YES];
        if ([event type] == NSLeftMouseUp)
            return NO;
    }
}

+ (void) fixSquareButtonsInView:(NSView *) view
{
    NSFont *font = [NSFont systemFontOfSize:[NSFont smallSystemFontSize]];
    
    if ([view isKindOfClass:[NSButton class]]) 
    {
        NSButton *button = (NSButton *)view;
        if ([button bezelStyle] == NSShadowlessSquareBezelStyle)
            [button setFont:font];
    }
    else
    {
        for (NSView *subview in [view subviews]) {
            [self fixSquareButtonsInView:subview];
        }
    }
}

@end
