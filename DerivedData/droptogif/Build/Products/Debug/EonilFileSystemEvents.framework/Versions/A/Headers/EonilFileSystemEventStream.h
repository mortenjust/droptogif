//
//  EonilFileSystemEventStream.h
//  EonilFileSystemEvents
//
//  Created by Hoon H. on 11/12/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

#import <Foundation/Foundation.h>

















/*
 *  FSEventStreamEventFlags
 *
 *  Discussion:
 *    Flags that can be passed to your FSEventStreamCallback function.
 *
 *    It is important to note that event flags are simply hints about the
 *    sort of operations that occurred at that path.
 *
 *    Furthermore, the FSEvent stream should NOT be treated as a form of
 *    historical log that could somehow be replayed to arrive at the
 *    current state of the file system.
 *
 *    The FSEvent stream simply indicates what paths changed; and clients
 *    need to reconcile what is really in the file system with their internal
 *    data model - and recognize that what is actually in the file system can
 *    change immediately after you check it.
 */

/*!
 Set to @c UInt32 because any other types didn't worked with current Swift compiler...
 */
typedef NS_OPTIONS(UInt32, EonilFileSystemEventFlag) {
	/*
	 * There was some change in the directory at the specific path
	 * supplied in this event.
	 */
	EonilFileSystemEventFlagNone	=	kFSEventStreamEventFlagNone,
	

	/*
	 * Your application must rescan not just the directory given in the
	 * event, but all its children, recursively. This can happen if there
	 * was a problem whereby events were coalesced hierarchically. For
	 * example, an event in /Users/jsmith/Music and an event in
	 * /Users/jsmith/Pictures might be coalesced into an event with this
	 * flag set and path=/Users/jsmith. If this flag is set you may be
	 * able to get an idea of whether the bottleneck happened in the
	 * kernel (less likely) or in your client (more likely) by checking
	 * for the presence of the informational flags
	 * kFSEventStreamEventFlagUserDropped or
	 * kFSEventStreamEventFlagKernelDropped.
	 */
	EonilFileSystemEventFlagMustScanSubDirs	=	kFSEventStreamEventFlagMustScanSubDirs,
	
	/*
	 * The kFSEventStreamEventFlagUserDropped or
	 * kFSEventStreamEventFlagKernelDropped flags may be set in addition
	 * to the kFSEventStreamEventFlagMustScanSubDirs flag to indicate
	 * that a problem occurred in buffering the events (the particular
	 * flag set indicates where the problem occurred) and that the client
	 * must do a full scan of any directories (and their subdirectories,
	 * recursively) being monitored by this stream. If you asked to
	 * monitor multiple paths with this stream then you will be notified
	 * about all of them. Your code need only check for the
	 * kFSEventStreamEventFlagMustScanSubDirs flag; these flags (if
	 * present) only provide information to help you diagnose the problem.
	 */
	EonilFileSystemEventFlagUserDropped		=	kFSEventStreamEventFlagUserDropped,
	EonilFileSystemEventFlagKernelDropped	=	kFSEventStreamEventFlagKernelDropped,
	
	/*
	 * If kFSEventStreamEventFlagEventIdsWrapped is set, it means the
	 * 64-bit event ID counter wrapped around. As a result,
	 * previously-issued event ID's are no longer valid arguments for the
	 * sinceWhen parameter of the FSEventStreamCreate...() functions.
	 */
	EonilFileSystemEventFlagEventIdsWrapped	=	kFSEventStreamEventFlagEventIdsWrapped,
	
	/*
	 * Denotes a sentinel event sent to mark the end of the "historical"
	 * events sent as a result of specifying a sinceWhen value in the
	 * FSEventStreamCreate...() call that created this event stream. (It
	 * will not be sent if kFSEventStreamEventIdSinceNow was passed for
	 * sinceWhen.) After invoking the client's callback with all the
	 * "historical" events that occurred before now, the client's
	 * callback will be invoked with an event where the
	 * kFSEventStreamEventFlagHistoryDone flag is set. The client should
	 * ignore the path supplied in this callback.
	 */
	EonilFileSystemEventFlagHistoryDone		=	kFSEventStreamEventFlagHistoryDone,
	
	/*
	 * Denotes a special event sent when there is a change to one of the
	 * directories along the path to one of the directories you asked to
	 * watch. When this flag is set, the event ID is zero and the path
	 * corresponds to one of the paths you asked to watch (specifically,
	 * the one that changed). The path may no longer exist because it or
	 * one of its parents was deleted or renamed. Events with this flag
	 * set will only be sent if you passed the flag
	 * kFSEventStreamCreateFlagWatchRoot to FSEventStreamCreate...() when
	 * you created the stream.
	 */
	EonilFileSystemEventFlagRootChanged		=	kFSEventStreamEventFlagRootChanged,
	
	/*
	 * Denotes a special event sent when a volume is mounted underneath
	 * one of the paths being monitored. The path in the event is the
	 * path to the newly-mounted volume. You will receive one of these
	 * notifications for every volume mount event inside the kernel
	 * (independent of DiskArbitration). Beware that a newly-mounted
	 * volume could contain an arbitrarily large directory hierarchy.
	 * Avoid pitfalls like triggering a recursive scan of a non-local
	 * filesystem, which you can detect by checking for the absence of
	 * the MNT_LOCAL flag in the f_flags returned by statfs(). Also be
	 * aware of the MNT_DONTBROWSE flag that is set for volumes which
	 * should not be displayed by user interface elements.
	 */
	EonilFileSystemEventFlagMount			=	kFSEventStreamEventFlagMount,
	
	/*
	 * Denotes a special event sent when a volume is unmounted underneath
	 * one of the paths being monitored. The path in the event is the
	 * path to the directory from which the volume was unmounted. You
	 * will receive one of these notifications for every volume unmount
	 * event inside the kernel. This is not a substitute for the
	 * notifications provided by the DiskArbitration framework; you only
	 * get notified after the unmount has occurred. Beware that
	 * unmounting a volume could uncover an arbitrarily large directory
	 * hierarchy, although Mac OS X never does that.
	 */
	EonilFileSystemEventFlagUnmount			=	kFSEventStreamEventFlagUnmount,
	
	/*
	 * A file system object was created at the specific path supplied in this event.
	 * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
	 */
	EonilFileSystemEventFlagItemCreated __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_6_0)	=	kFSEventStreamEventFlagItemCreated ,
	
	/*
	 * A file system object was removed at the specific path supplied in this event.
	 * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
	 */
	EonilFileSystemEventFlagItemRemoved __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_6_0) = kFSEventStreamEventFlagItemRemoved,
	
	/*
	 * A file system object at the specific path supplied in this event had its metadata modified.
	 * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
	 */
	EonilFileSystemEventFlagItemInodeMetaMod __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_6_0) = kFSEventStreamEventFlagItemInodeMetaMod,
	
	/*
	 * A file system object was renamed at the specific path supplied in this event.
	 * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
	 */
	EonilFileSystemEventFlagItemRenamed __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_6_0) = kFSEventStreamEventFlagItemRenamed,
	
	/*
	 * A file system object at the specific path supplied in this event had its data modified.
	 * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
	 */
	EonilFileSystemEventFlagItemModified __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_6_0) = kFSEventStreamEventFlagItemModified,
	
	/*
	 * A file system object at the specific path supplied in this event had its FinderInfo data modified.
	 * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
	 */
	EonilFileSystemEventFlagItemFinderInfoMod __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_6_0) = kFSEventStreamEventFlagItemFinderInfoMod,
	
	/*
	 * A file system object at the specific path supplied in this event had its ownership changed.
	 * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
	 */
	EonilFileSystemEventFlagItemChangeOwner __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_6_0) = kFSEventStreamEventFlagItemChangeOwner,
	
	/*
	 * A file system object at the specific path supplied in this event had its extended attributes modified.
	 * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
	 */
	EonilFileSystemEventFlagItemXattrMod __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_6_0) = kFSEventStreamEventFlagItemXattrMod,
	
	/*
	 * The file system object at the specific path supplied in this event is a regular file.
	 * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
	 */
	EonilFileSystemEventFlagItemIsFile __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_6_0) = kFSEventStreamEventFlagItemIsFile,
	
	/*
	 * The file system object at the specific path supplied in this event is a directory.
	 * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
	 */
	EonilFileSystemEventFlagItemIsDir __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_6_0) = kFSEventStreamEventFlagItemIsDir,
	
	/*
	 * The file system object at the specific path supplied in this event is a symbolic link.
	 * (This flag is only ever set if you specified the FileEvents flag when creating the stream.)
	 */
	EonilFileSystemEventFlagItemIsSymlink __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_6_0) = kFSEventStreamEventFlagItemIsSymlink,
	
	/*
	 * Indicates the event was triggered by the current process.
	 * (This flag is only ever set if you specified the MarkSelf flag when creating the stream.)
	 */
	EonilFileSystemEventFlagOwnEvent __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0) = kFSEventStreamEventFlagOwnEvent
	
};






/*!
 Provides only single-bit matching strings. If you need multi-bit matching, you need to decompose it yourself.
 */
NSString*
//NSStringFromEonilFileSystemEventFlag(EonilFileSystemEventFlag flag);
NSStringFromFSEventStreamEventFlags(FSEventStreamEventFlags flag);







/*!
 @param	events	An array of @c EonilSimpleFileSystemEvent objects. Ordered as provided.
 */
typedef void(^EonilFileSystemEventStreamCallback)(NSArray* events);










@interface	EonilFileSystemEvent : NSObject
@property	(readonly,nonatomic,copy)	NSString*						path;
@property	(readonly,nonatomic,assign)	EonilFileSystemEventFlag		flag;
@property	(readonly,nonatomic,assign)	FSEventStreamEventId			ID;
@end



/*!
 Tailored for use with Swift.
 Slower than @c EonilFileSystemEventStream class due to more allocation.
 This starts monitoring automatically when created, and stops when deallocated.
 This notifies all events immediately on the specified GCD queue.
 */
@interface	EonilFileSystemEventStream : NSObject
@property	(readwrite,nonatomic,strong)	dispatch_queue_t	queue;
/*!
 Creates a new instance with everything setup and starts immediately.

 @param		callback
			Called when some events notified. See @c EonilFileSystemEventStreamCallback for details.
 */
- (instancetype)initWithCallback:(EonilFileSystemEventStreamCallback)callback pathsToWatch:(NSArray*)pathsToWatch latency:(NSTimeInterval)latency watchRoot:(BOOL)watchRoot queue:(dispatch_queue_t)queue;
@end











