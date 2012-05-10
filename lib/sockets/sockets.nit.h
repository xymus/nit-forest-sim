/* file generated by nits for module sockets */

#ifndef sockets_IMPL_NIT_H
#define sockets_IMPL_NIT_H

#undef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE 1
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <netdb.h>
#include <errno.h>

#define CommunicationSocket int*
#define ListeningSocket int*

#include <sockets._nitni.h>

CommunicationSocket new_CommunicationSocket_connect_to___impl( String address, bigint port );
CommunicationSocket new_CommunicationSocket_from_fd___impl( bigint fd );
nullable_String CommunicationSocket_error___impl( CommunicationSocket recv );
void CommunicationSocket_close___impl( CommunicationSocket recv );
nullable_String CommunicationSocket_read___impl( CommunicationSocket recv );
void CommunicationSocket_write___impl( CommunicationSocket recv, String s );
ListeningSocket new_ListeningSocket_bind_to___impl( String address, bigint port );
nullable_String ListeningSocket_error___impl( ListeningSocket recv );
void ListeningSocket_close___impl( ListeningSocket recv );
nullable_CommunicationSocket ListeningSocket_accept___impl( ListeningSocket recv );

#endif
