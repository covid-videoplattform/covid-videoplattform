package main

import (
	"time"
)

type Videobridges struct {
	ID                                         uint
	Name                                       string
	HealthCheck                                uint
	audiochannels                              uint
	bit_rate_download                          uint
	bit_rate_upload                            uint
	conference_sizes                           []uint
	conferences                                uint
	cpu_usage                                  float32
	current_timestamp                          time
	graceful_shutdown                          bool
	jitter_aggregate                           uint
	largest_conference                         uint
	loss_rate_download                         uint
	loss_rate_upload                           uint
	packet_rate_download                       uint
	packet_rate_upload                         uint
	participants                               uint
	region                                     string
	relay_id                                   string
	rtp_loss                                   uint
	rtt_aggregate                              uint
	threads                                    uint
	total_bytes_received                       uint
	total_bytes_received_octo                  uint
	total_bytes_sent                           uint
	total_bytes_sent_octo                      uint
	total_colibri_web_socket_messages_received uint
	total_colibri_web_socket_messages_sent     uint
	total_conference_seconds                   uint
	total_conferences_completed                uint
	total_conferences_created                  uint
	total_data_channel_messages_received       uint
	total_data_channel_messages_sent           uint
	total_failed_conferences                   uint
	total_ice_failed                           uint
	total_ice_succeeded                        uint
	total_ice_succeeded_tcp                    uint
	total_loss_controlled_participant_seconds  uint
	total_loss_degraded_participant_seconds    uint
	total_loss_limited_participant_seconds     uint
	total_memory                               uint
	total_packets_dropped_octo                 uint
	total_packets_received                     uint
	total_packets_received_octo                uint
	total_packets_sent                         uint
	total_packets_sent_octo                    uint
	total_partially_failed_conferences         uint
	total_participants                         uint
	used_memory                                uint
	videochannels                              uint
	videostreams                               uint
}

type Staff struct {
	ID   uint
	Name string
}

type Patient struct {
	ID uint
}

type Appointment struct {
	ID       uint
	Patient  Patient
	Staff    Staff
	datetime time.Time
	URL      string
}
